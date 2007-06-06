Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXFFSfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXFFSfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbXFFSfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:35:16 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33288 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbXFFSfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:35:14 -0400
Message-ID: <4666FE9F.6010309@drzeus.cx>
Date: Wed, 06 Jun 2007 20:36:15 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] drivers/mmc/core/core.{h,c}: cleanups
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070604221349.GF5500@stusta.de>
In-Reply-To: <20070604221349.GF5500@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> This patch contains the following cleanups:
> - make the following needlessly global functions static:
>   - core.c: mmc_schedule_delayed_work()
>   - core.c: mmc_flush_scheduled_work()
> - removes the prototope of the following non-existing function:
>   - core.h: mmc_schedule_work()
> - proper prototypes for three functions from core.c in core.h
>  
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

Thanks, applied.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
