Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZLIIIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZLIIIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZLIIIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:08:31 -0500
Received: from [213.95.27.120] ([213.95.27.120]:53420 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZLIIIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:08:30 -0500
Date: Wed, 9 Dec 2009 08:17:38 +0100
From: Harald Welte <HaraldWelte@viatech.com>
To: Juerg Haefliger <juergh@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core
 temperature
Message-ID: <20091209071738.GI4292@prithivi.gnumonks.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org>
 <20090619231132.22296525@hyperion.delvare>
 <191fb4ca0906271134r2c9761e3la56bdea3f66b60f4@mail.gmail.com>
 <191fb4ca0908131142m4f976d98yb434da72257f64ea@mail.gmail.com>
 <20090819143223.GU5065@prithivi.gnumonks.org>
 <191fb4ca0908190952l773fca65y5b38c88a1bf029d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191fb4ca0908190952l773fca65y5b38c88a1bf029d2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Juerg,

On Wed, Aug 19, 2009 at 09:52:25AM -0700, Juerg Haefliger wrote:

> Do you have any answers to my previous questions:
> 
> 1) My driver uses the CPUID instruction to read the performance
> registers that contain the temp and voltage data. Harald's driver
> reads MSRs. I don't know if there are any benefits of using one method
> over the other.

not that I am aware of, at least nowhere in the documentation.  

> 2) If we pick Harald's, it would be nice if his driver can also read
> and export the CPU core voltage.

I'm willing to add that, but I really don't need to push my driver. It doesn't
matter to me, I just want those features supported in mainline.

> 3) Quite a few testers of my driver reported 0 temp readings for some
> C7 CPUs. I was never able to figure out why some CPUs return 0 temp
> but I'm guessing it depends on the thermal monitor settings. I'd like
> to understand what is going on and hope Harald can shed some light.

Unfortunately I cannot.    I can contact some of the CPU hardware folks about
it, but then it would probably have more details on which particular CPU models
(or mainbaords) exposed that behavior, and what exactly was their CPU version
(as seen from cpuid).

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
