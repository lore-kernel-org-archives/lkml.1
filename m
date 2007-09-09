Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXIIPHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXIIPHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbXIIPGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:06:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1882 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757437AbXIIPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:06:52 -0400
Date: Sun, 9 Sep 2007 14:42:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Will Simoneau <simoneau@ele.uri.edu>, jikos@jikos.cz
Subject: Re: [GIT PULL] VESA register clobber paranoia
Message-ID: <20070909144238.GB4777@ucw.cz>
References: <200708311937.l7VJbb3n018180@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708311937.l7VJbb3n018180@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Please pull:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus
> 
> H. Peter Anvin (1):
>       [x86 setup] Don't rely on the VESA BIOS being register-clean
> 
>  arch/i386/boot/video-vesa.c |   34 +++++++++++++++++++++-------------
>  1 files changed, 21 insertions(+), 13 deletions(-)
> 
> [Log messages and full diffs follow]
> 
> commit 4221d014ea04d439e6d1e65951c3b406e7c1b7ab
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Fri Aug 31 11:30:31 2007 -0700
> 
>     [x86 setup] Don't rely on the VESA BIOS being register-clean
>     
>     The VESA BIOS is specified to be register-clean.  However, we have now
>     found at least one system which violates that.  Thus, be as paranoid
>     about VESA calls as about everything else.
>     
>     Huge thanks to Will Simoneau for reporting, diagnosing, and testing
>     this out on Dell Inspiron 5150.

Was this the 'resume broken in -rc' problem?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
