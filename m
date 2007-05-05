Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXEERZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXEERZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbXEERZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:25:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46513 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075AbXEERZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:25:52 -0400
Date: Sat, 5 May 2007 10:55:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: simo <idra@samba.org>
Cc: Jeremy Allison <jra@samba.org>, Gerald Carter <coffeedude.jerry@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a	distinct module
Message-ID: <20070505095513.GA9935@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	simo <idra@samba.org>, Jeremy Allison <jra@samba.org>,
	Gerald Carter <coffeedude.jerry@gmail.com>,
	Steve French <smfrench@gmail.com>,
	linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com> <20070501090657.GA17949@infradead.org> <1178198489.28758.14.camel@localhost.localdomain> <20070503141742.GB20328@infradead.org> <1178203013.28758.29.camel@localhost.localdomain> <4639F5AD.20807@gmail.com> <20070504171200.GE31976@samba1> <1178300593.28758.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178300593.28758.85.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 05:43:13PM +0000, simo wrote:
> > Actually I disagree. I think Christoph is correct. These
> > are two independent protocols and should be in two different
> > modules.
> 
> They are independent the same way NFS v4 is independent from NFS v3 and
> v2. Independent but related, and most importantly, one is the fallback
> of the other.

Just FYI: although nfs2/3 and nfs4 are in the same kernel module they
actually are different file_system_types, and there is no automatic
fallback in the kernel.  Given how little is actually shared between
nfs v2/3 and 4 it might have been a better idea to make it a totally
separate module.

