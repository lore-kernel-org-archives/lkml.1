Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYDPTPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYDPTPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYDPTOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:14:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3738 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbYDPTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:14:52 -0400
Date: Wed, 16 Apr 2008 21:13:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: casey@schaufler-ca.com, sds@tycho.nsa.gov, crispin@crispincowan.com,
       serue@us.ibm.com, matthew@wil.cx, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
Message-ID: <20080416191315.GB3923@ucw.cz>
References: <1208182620.18883.92.camel@moss-spartans.epoch.ncsc.mil> <484889.77284.qm@web36604.mail.mud.yahoo.com> <200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The question of protections on the object named /etc/passwd came
> > up time and time again. The notion that /etc/passwd could be a
> > symlink to /home/smalley/heeheehee really gave evaluators the
> > whillies. As did the chroot environment, where /roots/crispin/etc/passwd
> > could magicly become /etc/passwd.
> Why do people continue speaking symlinks and chroots?
> To avoid the effect of symlinks and chroots, AppArmor and TOMOYO Linux
> derive pathnames from dentry and vfsmount.
> If /etc/passwd was a symlink, the derived pathname will be /home/smalley/heeheehee.
> If accessed from inside a chroot, the derived pathname will be /roots/crispin/etc/passwd.
> 
> It is true that namespace may differ between processes,
> but I think that that is the matter of how to restrict namespace manipulation operations.
> As I said, a system can't survive if namespace is madly manipulated.
> To keep the system workable, /bin/ must be the directory for binary programs,
> /etc/ must be the directory for configuration files, and so on in all namespaces.

Ehm? Where did you get those ideas?

I'm free to name my directories any way I want, and keep config files
in /pavlix_config, thank you... There is even distro that does
something like that, IIRC...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
