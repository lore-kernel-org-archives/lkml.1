Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbXFUTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbXFUTxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXFUTxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:53:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60270 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757172AbXFUTxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:53:01 -0400
Date: Thu, 21 Jun 2007 21:52:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Lars Marowsky-Bree <lmb@suse.de>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621195247.GF18990@elf.ucw.cz>
References: <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <Pine.LNX.4.64.0706211136520.31603@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706211136520.31603@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>The code has improved, and continues to improve, to meet all the coding
> >>style feedback except the bits which are essential to AA's function
> >
> >Which are exactly the bits Christoph Hellwig and Al Viro
> >vetoed. http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/2587.html
> >. I believe it takes more than "2 users want it" to overcome veto of
> >VFS maintainer.
> 
> so you are saying that _any_ pathname based solution is not acceptable to 
> the kernel, no matter what?

You'd have to ask Christoph the same question.

AFAICT, reconstructing full path then basing security on that is a
no-no.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
