Return-Path: <linux-kernel-owner+w=401wt.eu-S938814AbXFHPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938814AbXFHPMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938322AbXFHPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:11:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2730 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756645AbXFHPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:11:17 -0400
Date: Thu, 7 Jun 2007 14:28:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Paris <eparis@redhat.com>, Alan Cox <alan@redhat.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sds@tycho.nsa.gov, sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Message-ID: <20070607142802.GB9094@ucw.cz>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> <20070603205653.GE25869@devserv.devel.redhat.com> <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> <1181075666.3978.31.camel@localhost.localdomain> <Line.LNX.4.64.0706051658170.23379@d.namei> <20070605211616.GE23291@devserv.devel.redhat.com> <1181078927.3978.42.camel@localhost.localdomain> <4665E7CA.8030907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4665E7CA.8030907@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > While I understand, there are a few users who will have problems with
> > this default are we really better to not provide this defense in depth
> > for the majority of users and let those with problems turn it off rather
> > than provide no defense by default?  I could even provide a different
> > default for SELinux and non-SELinux if anyone saw value in that?  But if
> > others think that off default is  best I'll send another patch shortly
> > with the unsigned long fix and the default set to 0.  My hope is then
> > that distros will figure out to turn this on.
> > 
> 
> I hope not.  This breaks any hardware virtualizer.
> 
> So yes, we're better off not having this on, and require it to be
> explicitly enabled by the end user.

You could do something like 4G+4G patches.... but performance penalty
would be ugly.

But no, we cant break userspace 'by default'.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
