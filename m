Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYBQOVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYBQOVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYBQOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:21:05 -0500
Received: from defiant.darkvoyage.org.uk ([81.187.177.18]:33660 "EHLO
	defiant.darkvoyage.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbYBQOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:21:04 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 09:21:03 EST
Message-ID: <47B8413A.80105@lkml.darkvoyage.org.uk>
Date: Sun, 17 Feb 2008 14:14:18 +0000
From: Iain Paton <ilp@lkml.darkvoyage.org.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
CC: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
References: <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com> <47934B2E.3020707@i4.informatik.rwth-aachen.de> <20080121170700.GC6884@cosmic.amd.com> <4794E664.6020209@i4.informatik.rwth-aachen.de>
In-Reply-To: <4794E664.6020209@i4.informatik.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:

> I can confirm that it is still working fine :-)

Hi,

Has anyone managed to build this as a module against the full 2.6.24 
release ?

I am seeing the following error:

   CC [M]  lib/zlib_inflate/infutil.o
   CC [M]  lib/zlib_inflate/inftrees.o
   CC [M]  lib/zlib_inflate/inflate_syms.o
   LD [M]  lib/zlib_inflate/zlib_inflate.o
   Building modules, stage 2.
   MODPOST 251 modules
ERROR: "geode_mfgpt_toggle_event" [drivers/watchdog/geodewdt.ko] undefined!
ERROR: "geode_mfgpt_alloc_timer" [drivers/watchdog/geodewdt.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


arch/x86/kernel/mfgpt_32.c where these are defined seems to have been 
built ok and they appear in System.map.

The only other thing I've done is to add "[PATCH] pata_cs5536 Fix 
secondary port configuration" recently posted by Martin K. Petersen but 
I don't believe that would cause this.

.config is available at http://pastebin.ca/907299

Iain


