Return-Path: <linux-kernel-owner+w=401wt.eu-S1162085AbXECOxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162085AbXECOxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162087AbXECOxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:53:19 -0400
Received: from mail.samba.org ([66.70.73.150]:34359 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162085AbXECOxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:53:17 -0400
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a
	distinct module
From: simo <idra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070503144315.GA24129@infradead.org>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
	 <1178203013.28758.29.camel@localhost.localdomain>
	 <20070503144315.GA24129@infradead.org>
Content-Type: text/plain
Organization: Samba Team
Date: Thu, 03 May 2007 10:53:16 -0400
Message-Id: <1178203996.28758.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 15:43 +0100, Christoph Hellwig wrote:
> On Thu, May 03, 2007 at 10:36:53AM -0400, simo wrote:
> > I guess DFS referrals can work cross protocol, so if you are redirected
> > from a longhorn server to a windoes 2000 or a samba server you want to
> > be able to follow the DFS referral and not return an error.
> > To do that you need to have either 1 module that support both protocols
> > or a way from one module to call the other. Just separating the 2
> > without any glue will not work (or you will have to add some userspace
> > upcall hack to make it work).
> 
> You can easily redirect from one filesystem to another through
> ->follow_link, and you can mount new filesystems instances from there.
> 
> Can we please stop the bullshitting now?  And can you please get a realname
> before playing smart ass on filesystem developers lists?

I guess you just had a bad day and are in a bad mood, I am have no
interest in arguing with you if this is the tone of the discussion.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer
email: idra@samba.org
http://samba.org

