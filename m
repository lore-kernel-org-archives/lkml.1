Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXCVJMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXCVJMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXCVJME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:12:04 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:60721 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbXCVJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:12:03 -0400
Message-ID: <052c01c76c62$78f7f7a0$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: <bunk@stusta.de>
Subject: [RFC] - Schedule mcdx for removal ? was:  warning: #warning You have not edited mcdx.h
Date: Thu, 22 Mar 2007 10:14:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

anyway - i wonder if anybody is ever using 2.6.21+ on a system with one of 
those legacy mitsumi single-speed (LU-005/FX-001) and double-speed (FX-001D) 
cd-rom drives !?

iirc, these where the first drives available on the market (must have been 
around '94) and those were no ide/atapi compatible drives which had their 
own isa-bus controller.

i wonder if there still exist any of those devices in functional state in 
this world, at least not attached to some system being able to boot 
2.6.21+ - so, maybe mcdx driver is something for 
Documentation/feature-removal-schedule.txt , being removed in 2.6.25 or so 
after being announced for some time (i.e. driver telling "i will be gone 
soon, go spend those $15 to get a new drive") ?

not 100% sure here, but there really may be nobody to complain about 
removing this one.....

regards
roland

ps:
hey, i just read discussions about removing RAW driver, so if THAT being 
discussed for removal, this one probably should have been removed already ! 
;)


----- Original Message ----- 
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: <bunk@stusta.de>
Sent: Thursday, March 22, 2007 1:43 AM
Subject: warning: #warning You have not edited mcdx.h


> while looking at some more warnings i got with allyesconfig i came across 
> this really weird one:
>
> In file included from drivers/cdrom/mcdx.c:78:
> drivers/cdrom/mcdx.h:180:2: warning: #warning You have not edited mcdx.h
> drivers/cdrom/mcdx.h:181:2: warning: #warning Perhaps irq and i/o settings 
> are wrong.
>
> looking into the code :
>
> #ifndef I_WAS_HERE
> #ifndef MODULE
> #warning You have not edited mcdx.h
> #warning Perhaps irq and i/o settings are wrong.
> #endif
> #endif
>
> and before:
> /* *** make the following line uncommented, if you're sure,
> * *** all configuration is done */
> /* #define I_WAS_HERE */
>
> huh?
>
> is this file meant to be edited before compile ?
>
>
> searched the list and came across some patch from adrian bunk:
>
> [Patch] (new version) configure mcdx without editing mcdx.h
>
> at http://marc.info/?l=linux-kernel&m=94772887906874&w=2
> and http://marc.info/?l=linux-kernel&m=94724271712637&w=2
> and http://marc.info/?l=linux-kernel&m=94699770112439&w=2
>
> has this never been merged ?
>
> regards
> roland
>
>
> 

