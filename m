Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbXHPVAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbXHPVAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXHPVAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:00:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4945 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757278AbXHPVAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:00:40 -0400
Date: Thu, 16 Aug 2007 20:58:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070816205833.GC4949@ucw.cz>
References: <10247DAA-D04B-42D5-B67B-C2D3BD42A94F@mac.com> <134690.82938.qm@web36611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <134690.82938.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I will write you a Perl script which will generate a complete  
> > and functionally equivalent SELinux policy (assuming I have enough  
> > free time) given a file with your policy language.  But I can do this  
> > if and only if you tell me which of the SELinux access vectors you  
> > care about (In other words, which of the LSM hooks you want to  
> > require "read", "write", or "execute" privileges for).  With such a  
> > little script you could write all the "simplified" policy you want,  
> > without having to change the kernel code at all.
> 
> It's all spelled out in the module. Go wild.

Kyle claims he can emulate SMACK with SELinux + perl script, but I
don't think it is fair to force him to write that perl. You want the
code merged, so it should be up to you to do the work... or
acknowledge that selinux ineed is smack supperset and argue that SMACK
is better, anyway, because of its simplicity / speed / something.

Or maybe that perl script is impossible to write for some reason? Tell
us if so...
							Pavel
				(who is no security expert)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
