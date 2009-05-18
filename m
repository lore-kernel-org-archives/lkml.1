Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZEROF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZEROF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZEROFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:05:50 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:28491 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751968AbZEROFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:05:49 -0400
Message-ID: <759339.47729.qm@web32606.mail.mud.yahoo.com>
X-YMail-OSG: hOXCcYsVM1nnxbJfxIXlk5f43u4CRSzpKwgRnavzACPwPi5pa6inHyVW
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.ffB.HZzDKB@chimera>
Date: Mon, 18 May 2009 07:05:47 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13177] 2.6.30-rc2-git7 build problem
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, oliver@neukum.name
In-Reply-To: <385Pu-agh7M.A.ffB.HZzDKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




----- Original Message ----
> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> Sent: Saturday, May 16, 2009 9:20:40 PM
> Subject: [Bug #13177] 2.6.30-rc2-git7 build problem
> 
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13177
> Subject        : 2.6.30-rc2-git7 build problem
> Submitter    : Martin Knoblauch 
> Date        : 2009-04-21 13:39 (26 days old)
> References    : http://marc.info/?l=linux-kernel&m=124032163602132&w=4
>           http://lkml.org/lkml/2009/4/27/56

 Still a problem in 2.6.30-rc6-git3. Adding maintainer

BUILD   arch/x86/boot/bzImage
Root device is (104, 3)
Setup is 12664 bytes (padded to 12800 bytes).
System is 2648 kB
CRC 91a1a400
Kernel: arch/x86/boot/bzImage is ready  (#2)
  Building modules, stage 2.
  MODPOST 471 modules
WARNING: drivers/gpu/drm/i915/i915.o(.text+0x1313e): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
The function intel_lvds_init() references
the variable __initdata intel_no_lvds.
This is often because intel_lvds_init lacks a __initdata
annotation or the annotation of intel_no_lvds is wrong.

ERROR: ".L192" [drivers/usb/serial/kl5kusb105.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Cheers
Martin
