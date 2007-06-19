Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXFSP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXFSP0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXFSP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:26:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2885 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754273AbXFSP0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:26:05 -0400
Date: Tue, 19 Jun 2007 15:25:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
Cc: crispin@novell.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
Message-ID: <20070619152555.GB5127@ucw.cz>
References: <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <200706160948.FEH12774.MTtPGSNN@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706160948.FEH12774.MTtPGSNN@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In a smaller scale example, I want to share some files with a friend. I
> > can't be bothered to set up a proper access control system, so I just mv
> > the files to ~crispin/public_html/lookitme and in IRC say "get it now,
> > going away in 10 minutes" and then move it out again. Yes, you can
> > manually address this by running "restorecon ~crispin/public_html". But
> > AA does this automatically without having to run any commands.
> If you share ~crispin/public_html/lookitme by making a hard link,
> does relabeling approach work?
> I thought SELinux allows only one label for one file.
> If AA (on the top of SELinux) tries to allow different permissions to
> ~crispin/public_html/lookitme and its original location,
> either one of two pathnames won't be accessible as intended, will it?

Yes, that's a bug/feature in AA. No, selinux will not be able to emulate that
bug/feature. Yes, it is dangerous, as it makes AA mostly useless on
multiuser machines.

(ln /etc/shadow /tmp is something any user can do, and all you need is
to exploit any daemon with access to /tmp).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
