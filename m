Return-Path: <linux-kernel-owner+w=401wt.eu-S1161268AbXECOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268AbXECOnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162028AbXECOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:43:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34201 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161268AbXECOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:43:17 -0400
Date: Thu, 3 May 2007 15:43:15 +0100
From: Christoph Hellwig <hch@infradead.org>
To: simo <idra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a distinct module
Message-ID: <20070503144315.GA24129@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	simo <idra@samba.org>, Steve French <smfrench@gmail.com>,
	linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com> <20070501090657.GA17949@infradead.org> <1178198489.28758.14.camel@localhost.localdomain> <20070503141742.GB20328@infradead.org> <1178203013.28758.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178203013.28758.29.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:36:53AM -0400, simo wrote:
> I guess DFS referrals can work cross protocol, so if you are redirected
> from a longhorn server to a windoes 2000 or a samba server you want to
> be able to follow the DFS referral and not return an error.
> To do that you need to have either 1 module that support both protocols
> or a way from one module to call the other. Just separating the 2
> without any glue will not work (or you will have to add some userspace
> upcall hack to make it work).

You can easily redirect from one filesystem to another through
->follow_link, and you can mount new filesystems instances from there.

Can we please stop the bullshitting now?  And can you please get a realname
before playing smart ass on filesystem developers lists?
