Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbZLKXXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbZLKXXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbZLKXXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:23:43 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47277 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762731AbZLKXXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K9k669DhFXePWM5bH6hvUVPqO8KEM9SxAB5r75+EbbOVEAvogR71Pqg78SM1sZdDNA
         zLFiufI6WuqtIw2iqwqr7xPA46UWYpvjYAcfzzgDPmEQKBgnRTrFiEUU3uAlRVmFV2UI
         ZmKsgYU5sARnQgzucTNoXUyVQJZtHaUnk55XU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
Date: Sat, 12 Dec 2009 00:23:47 +0100
Message-ID: <6a89f9d50912111523r178c0casb61fca1198f6f253@mail.gmail.com>
Subject: Re: [git pull] drm nouveau pony for Xmas.
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/11 Dave Airlie <airlied@linux.ie>:
>
> Hi Linus,
>
> Please pull the 'drm-nouveau-pony' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-nouveau-pony
>
> This contains the nouveau driver with Kconfig under staging for now, the
> code is going under drm because the upstream tree has it there, and it
> makes passing patches a lot easier at least initially.
>
> Thanks to Ben Skeggs for doing overtime on his Friday evening to get the
> ctxprogs ripped out and firmware loader support added. The firmware is
> available elsewhere via the nouveau project linux git tree, and comes with
> all the warnings mentioned about possible copyright issues.
>
> After this I also hope to merge the VMware virtual GPU kms driver early
> next week which is also TTM based and going into staging.
>
> The driver alone is ~36,000 lines of code, which is bigger than most
> subsystems we carry, so hopefully ppl realise the monumental scale of
> writing a driver for these things.
>
> Dave.
>
>  drivers/gpu/drm/Makefile                    |    2 +
>  drivers/gpu/drm/i2c/Makefile                |    4 +
>  drivers/gpu/drm/i2c/ch7006_drv.c            |  531 +++
>  drivers/gpu/drm/i2c/ch7006_mode.c           |  473 +++
>  drivers/gpu/drm/i2c/ch7006_priv.h           |  344 ++
>  drivers/gpu/drm/nouveau/Kconfig             |   44 +
>  drivers/gpu/drm/nouveau/Makefile            |   31 +
>  drivers/gpu/drm/nouveau/nouveau_acpi.c      |  125 +
>  drivers/gpu/drm/nouveau/nouveau_backlight.c |  155 +
>  drivers/gpu/drm/nouveau/nouveau_bios.c      | 6095 +++++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_bios.h      |  289 ++
>  drivers/gpu/drm/nouveau/nouveau_bo.c        |  671 +++
>  drivers/gpu/drm/nouveau/nouveau_calc.c      |  478 +++
>  drivers/gpu/drm/nouveau/nouveau_channel.c   |  468 ++
>  drivers/gpu/drm/nouveau/nouveau_connector.c |  824 ++++
>  drivers/gpu/drm/nouveau/nouveau_connector.h |   54 +
>  drivers/gpu/drm/nouveau/nouveau_crtc.h      |   95 +
>  drivers/gpu/drm/nouveau/nouveau_debugfs.c   |  155 +
>  drivers/gpu/drm/nouveau/nouveau_display.c   |  115 +
>  drivers/gpu/drm/nouveau/nouveau_dma.c       |  206 +
>  drivers/gpu/drm/nouveau/nouveau_dma.h       |  157 +
>  drivers/gpu/drm/nouveau/nouveau_dp.c        |  569 +++
>  drivers/gpu/drm/nouveau/nouveau_drv.c       |  405 ++
>  drivers/gpu/drm/nouveau/nouveau_drv.h       | 1286 ++++++
>  drivers/gpu/drm/nouveau/nouveau_encoder.h   |   91 +
>  drivers/gpu/drm/nouveau/nouveau_fb.h        |   47 +
>  drivers/gpu/drm/nouveau/nouveau_fbcon.c     |  380 ++
>  drivers/gpu/drm/nouveau/nouveau_fbcon.h     |   47 +
>  drivers/gpu/drm/nouveau/nouveau_fence.c     |  262 ++
>  drivers/gpu/drm/nouveau/nouveau_gem.c       |  992 +++++
>  drivers/gpu/drm/nouveau/nouveau_hw.c        | 1080 +++++
>  drivers/gpu/drm/nouveau/nouveau_hw.h        |  455 ++
>  drivers/gpu/drm/nouveau/nouveau_i2c.c       |  269 ++
>  drivers/gpu/drm/nouveau/nouveau_i2c.h       |   52 +
>  drivers/gpu/drm/nouveau/nouveau_ioc32.c     |   72 +
>  drivers/gpu/drm/nouveau/nouveau_irq.c       |  702 +++
>  drivers/gpu/drm/nouveau/nouveau_mem.c       |  568 +++
>  drivers/gpu/drm/nouveau/nouveau_notifier.c  |  196 +
>  drivers/gpu/drm/nouveau/nouveau_object.c    | 1294 ++++++
>  drivers/gpu/drm/nouveau/nouveau_reg.h       |  836 ++++
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c     |  321 ++
>  drivers/gpu/drm/nouveau/nouveau_state.c     |  811 ++++
>  drivers/gpu/drm/nouveau/nouveau_ttm.c       |  131 +
>  drivers/gpu/drm/nouveau/nv04_crtc.c         | 1002 +++++
>  drivers/gpu/drm/nouveau/nv04_cursor.c       |   70 +
>  drivers/gpu/drm/nouveau/nv04_dac.c          |  528 +++
>  drivers/gpu/drm/nouveau/nv04_dfp.c          |  621 +++
>  drivers/gpu/drm/nouveau/nv04_display.c      |  288 ++
>  drivers/gpu/drm/nouveau/nv04_fb.c           |   21 +
>  drivers/gpu/drm/nouveau/nv04_fbcon.c        |  316 ++
>  drivers/gpu/drm/nouveau/nv04_fifo.c         |  271 ++
>  drivers/gpu/drm/nouveau/nv04_graph.c        |  579 +++
>  drivers/gpu/drm/nouveau/nv04_instmem.c      |  208 +
>  drivers/gpu/drm/nouveau/nv04_mc.c           |   20 +
>  drivers/gpu/drm/nouveau/nv04_timer.c        |   51 +
>  drivers/gpu/drm/nouveau/nv04_tv.c           |  305 ++
>  drivers/gpu/drm/nouveau/nv10_fb.c           |   24 +
>  drivers/gpu/drm/nouveau/nv10_fifo.c         |  260 ++
>  drivers/gpu/drm/nouveau/nv10_graph.c        |  892 ++++
>  drivers/gpu/drm/nouveau/nv17_gpio.c         |   92 +
>  drivers/gpu/drm/nouveau/nv17_tv.c           |  681 +++
>  drivers/gpu/drm/nouveau/nv17_tv.h           |  156 +
>  drivers/gpu/drm/nouveau/nv17_tv_modes.c     |  583 +++
>  drivers/gpu/drm/nouveau/nv20_graph.c        |  780 ++++
>  drivers/gpu/drm/nouveau/nv40_fb.c           |   62 +
>  drivers/gpu/drm/nouveau/nv40_fifo.c         |  314 ++
>  drivers/gpu/drm/nouveau/nv40_graph.c        |  560 +++
>  drivers/gpu/drm/nouveau/nv40_mc.c           |   38 +
>  drivers/gpu/drm/nouveau/nv50_crtc.c         |  769 ++++
>  drivers/gpu/drm/nouveau/nv50_cursor.c       |  156 +
>  drivers/gpu/drm/nouveau/nv50_dac.c          |  304 ++
>  drivers/gpu/drm/nouveau/nv50_display.c      | 1015 +++++
>  drivers/gpu/drm/nouveau/nv50_display.h      |   46 +
>  drivers/gpu/drm/nouveau/nv50_evo.h          |  113 +
>  drivers/gpu/drm/nouveau/nv50_fbcon.c        |  273 ++
>  drivers/gpu/drm/nouveau/nv50_fifo.c         |  494 +++
>  drivers/gpu/drm/nouveau/nv50_graph.c        |  385 ++
>  drivers/gpu/drm/nouveau/nv50_instmem.c      |  509 +++
>  drivers/gpu/drm/nouveau/nv50_mc.c           |   40 +
>  drivers/gpu/drm/nouveau/nv50_sor.c          |  309 ++
>  drivers/gpu/drm/nouveau/nvreg.h             |  535 +++
>  drivers/staging/Kconfig                     |    2 +
>  include/drm/Kbuild                          |    1 +
>  include/drm/i2c/ch7006.h                    |   86 +
>  include/drm/nouveau_drm.h                   |  220 +
>  85 files changed, 36161 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpu/drm/i2c/Makefile
>  create mode 100644 drivers/gpu/drm/i2c/ch7006_drv.c
>  create mode 100644 drivers/gpu/drm/i2c/ch7006_mode.c
>  create mode 100644 drivers/gpu/drm/i2c/ch7006_priv.h
>  create mode 100644 drivers/gpu/drm/nouveau/Kconfig
>  create mode 100644 drivers/gpu/drm/nouveau/Makefile
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_acpi.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_backlight.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_bios.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_bios.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_bo.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_calc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_channel.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_connector.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_connector.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_crtc.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_debugfs.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_display.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_dma.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_dma.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_dp.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_drv.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_drv.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_encoder.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_fb.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_fbcon.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_fbcon.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_fence.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_gem.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_hw.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_hw.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_i2c.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_i2c.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_ioc32.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_irq.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_mem.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_notifier.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_object.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_reg.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_sgdma.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_state.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_ttm.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_crtc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_cursor.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_dac.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_dfp.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_display.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_fb.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_fbcon.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_fifo.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_graph.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_instmem.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_mc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_timer.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_tv.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv10_fb.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv10_fifo.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv10_graph.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv17_gpio.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv17_tv.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv17_tv.h
>  create mode 100644 drivers/gpu/drm/nouveau/nv17_tv_modes.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv20_graph.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv40_fb.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv40_fifo.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv40_graph.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv40_mc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_crtc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_cursor.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_dac.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_display.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_display.h
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_evo.h
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_fbcon.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_fifo.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_graph.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_instmem.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_mc.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_sor.c
>  create mode 100644 drivers/gpu/drm/nouveau/nvreg.h
>  create mode 100644 include/drm/i2c/ch7006.h
>  create mode 100644 include/drm/nouveau_drm.h
>
> commit 6ee738610f41b59733f63718f0bdbcba7d3a3f12
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Fri Dec 11 19:24:15 2009 +1000
>
>    drm/nouveau: Add DRM driver for NVIDIA GPUs
>
>    This adds a drm/kms staging non-API stable driver for GPUs from NVIDIA.
>
>    This driver is a KMS-based driver and requires a compatible nouveau
>    userspace libdrm and nouveau X.org driver.
>
>    This driver requires firmware files not available in this kernel tree,
>    interested parties can find them via the nouveau project git archive.
>
>    This driver is reverse engineered, and is in no way supported by nVidia.
>
>    Support for nearly the complete range of nvidia hw from nv04->g80 (nv50)
>    is available, and the kms driver should support driving nearly all
>    output types (displayport is under development still) along with supporting
>    suspend/resume.
>
>    This work is all from the upstream nouveau project found at
>    nouveau.freedesktop.org.
>
>    The original authors list from nouveau git tree is:
>    Anssi Hannula <anssi.hannula@iki.fi>
>    Ben Skeggs <bskeggs@redhat.com>
>    Francisco Jerez <currojerez@riseup.net>
>    Maarten Maathuis <madman2003@gmail.com>
>    Marcin Ko¶cielnicki <koriakin@0x04.net>
>    Matthew Garrett <mjg@redhat.com>
>    Matt Parnell <mparnell@gmail.com>
>    Patrice Mandin <patmandin@gmail.com>
>    Pekka Paalanen <pq@iki.fi>
>    Xavier Chantry <shiningxc@gmail.com>
>    along with project founder Stephane Marchesin <marchesin@icps.u-strasbg.fr>
>

Btw could we get proper developer credit here? I think 3/4 of the
people who wrote the code are missing here.

Stephane
