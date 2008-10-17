Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJQKQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJQKQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYJQKQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:16:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39178 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752372AbYJQKQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:16:10 -0400
Date: Fri, 17 Oct 2008 12:15:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Russell King <rmk@arm.linux.org.uk>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: 2.6.27-git6: no longer compiles on zaurus
Message-ID: <20081017101557.GA10850@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...it should be easy to fix.... but I can't find cpu_is_pxa21x in the
headers....?

								Pavel

  CHK     include/linux/version.h
make[1]: `include/asm-arm/mach-types.h' is up to date.
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
<stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
<stdin>:1321:2: warning: #warning syscall pselect6 not implemented
<stdin>:1325:2: warning: #warning syscall ppoll not implemented
<stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
  CHK     include/linux/compile.h
  CC [M]  sound/arm/pxa2xx-ac97-lib.o
In file included from sound/arm/pxa2xx-ac97-lib.c:26:
arch/arm/mach-pxa/include/mach/pxa2xx-gpio.h:4:2: warning: #warning Please use mfp-pxa2[57]x.h instead of pxa2xx-gpio.h
sound/arm/pxa2xx-ac97-lib.c: In function 'pxa2xx_ac97_read':
sound/arm/pxa2xx-ac97-lib.c:53: error: implicit declaration of function 'cpu_is_pxa21x'
make[2]: *** [sound/arm/pxa2xx-ac97-lib.o] Error 1
make[1]: *** [sound/arm] Error 2
make: *** [sound] Error 2


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
