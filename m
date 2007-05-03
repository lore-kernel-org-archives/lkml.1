Return-Path: <linux-kernel-owner+w=401wt.eu-S1161959AbXECORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161959AbXECORs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161969AbXECORr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:17:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55710 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161959AbXECORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:17:46 -0400
Date: Thu, 3 May 2007 15:17:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: simo <idra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a distinct module
Message-ID: <20070503141742.GB20328@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	simo <idra@samba.org>, Steve French <smfrench@gmail.com>,
	linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com> <20070501090657.GA17949@infradead.org> <1178198489.28758.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178198489.28758.14.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:21:29AM -0400, simo wrote:
> Separate modules would mean the user have to know which protocol to
> choose each time. And this make little sense.

Of course it makes a lot of sense.  We don't have anyfs.ko either
because some ubuntu users are too braindead to know what's on their
disk.

> You really want to auto-negotiate which protocol to use, because you
> could have at the same time a connection to a Vista/Longhorn (SMB2)
> machine and one to a Windows 2000 server (plain SMB) in the same domain
> using the same credentials.

So what?

