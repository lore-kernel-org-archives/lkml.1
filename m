Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHSWLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHSWLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYHSWK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:10:58 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52250 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYHSWK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:10:57 -0400
Message-ID: <48AB44EB.90707@lwfinger.net>
Date: Tue, 19 Aug 2008 17:10:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
References: <48A63D98.3070900@lwfinger.net> <20080818193253.GA30856@uranus.ravnborg.org> <48A9FA05.9000601@lwfinger.net> <20080819044854.GA2276@uranus.ravnborg.org> <1219132135.3184.461.camel@pmac.infradead.org> <48AAFB4C.1030300@lwfinger.net> <20080819192508.GA6774@uranus.ravnborg.org>
In-Reply-To: <20080819192508.GA6774@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Aug 19, 2008 at 11:56:44AM -0500, Larry Finger wrote:
>> sudo make V=2 modules_install says:
>>
>>   HOSTCC  firmware/ihex2fw - due to: /usr/include/gnu/stubs-64.h 
>> /usr/lib64/gcc/x86_64-suse-linux/4.3/include/stddef.h 
>> /usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/limits.h 
>> /usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/syslimits.h 
>> /usr/lib64/gcc/x86_64-suse-linux/4.3/include/stdarg.h
>> /bin/sh: scripts/basic/fixdep: cannot execute binary file
>> make[1]: *** [firmware/ihex2fw] Error 126
>> make: *** [_modinst_post] Error 2
> 
> Do you have some logging info before we start to build ihex2fw?

Only one line like these for each of the modules, followed immediately 
by the build of ihex2fw:

   INSTALL sound/core/snd.ko - due to target is PHONY
   INSTALL sound/drivers/mpu401/snd-mpu401-uart.ko - due to target is 
PHONY
   INSTALL sound/drivers/mpu401/snd-mpu401.ko - due to target is PHONY
   INSTALL sound/drivers/opl3/snd-opl3-lib.ko - due to target is PHONY
   INSTALL sound/drivers/opl3/snd-opl3-synth.ko - due to target is PHONY
   INSTALL sound/pci/ac97/snd-ac97-codec.ko - due to target is PHONY
   INSTALL sound/pci/snd-es1938.ko - due to target is PHONY
   INSTALL sound/soundcore.ko - due to target is PHONY
   HOSTCC  firmware/ihex2fw - due to: /usr/include/gnu/stubs-64.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include/stddef.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/limits.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/syslimits.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include/stdarg.h
/bin/sh: scripts/basic/fixdep: cannot execute binary file
make[1]: *** [firmware/ihex2fw] Error 126
make: *** [_modinst_post] Error 2


Larry
