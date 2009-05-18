Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZERTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZERTBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZERTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:01:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56870 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZERTBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:01:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [i915] Kernel does not compile when set to use i915 kernel mode-setting per default (CONFIG_DRM_I915_KMS=y)
Date: Mon, 18 May 2009 21:01:06 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
References: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
In-Reply-To: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
Cc: Zorael <zorael@gmail.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182101.06511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CCs.

On Monday 18 May 2009, you wrote:
> (First post, so please CC to zorael@gmail.com in case it doesn't automatically.)
> 
> 
> I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
> default*, for my Intel 945GME video chipset. Alas, when compiling, it
> halts with the following tidbit:
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `intel_opregion_free':
> /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
> reference to `acpi_video_exit'
> drivers/built-in.o: In function `intel_opregion_init':
> /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
> reference to `acpi_video_register'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/usr/src/linux-2.6.29'
> make: *** [debian/stamp/build/kernel] Error 2
> 
> 
> grepping acpi_video_register recursively I see it's defined as an
> empty function in ./include/acpi/video.h, and as a more proper
> function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
> per default via CONFIG_DRM_I915_KMS=y stop it from reading those
> files?
> 
> I used to run with KMS by default in the early -30rc*s, but at some
> point (rc2?), it stopped compiling succesfully. If I don't enable it
> per default, it *does* compile, though I don't know how to explicitly
> enable it at boot-time. So I'm living without KMS for the time being.
> Woe.
> 
> Anything obvious I'm doing wrong?
> 
> -- Zorael
