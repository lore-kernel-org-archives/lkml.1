Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYAHTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYAHTWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYAHTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:22:06 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:51942 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748AbYAHTWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:22:05 -0500
Date: Tue, 8 Jan 2008 20:21:57 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080108202157.0b8d3393@poseidon.drzeus.cx>
In-Reply-To: <200801081329.39611.vapier.adi@gmail.com>
References: <200801081329.39611.vapier.adi@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 13:29:39 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> The on-chip Blackfin MMC/SD/SDIO host controller has the ability to do 1-bit
> MMC, 1-bit/4-bit SD, and 1-bit/4-bit SDIO.  Thus the current convention of
> MMC_CAP_4_BIT_DATA meaning "your host controller can do 1-bit or 4-bit for all
> modes" is insufficient for our needs.  The attached patch splits
> MMC_CAP_4_BIT_DATA into MMC_CAP_MMC_4_BIT_DATA and MMC_CAP_SD_4_BIT_DATA and
> updates all host controllers to include these in their caps and then changes
> existing code to check the new defines.  At the moment, SD/SDIO are lumped
> into MMC_CAP_SD_4_BIT_DATA ... should I bother with splitting that into SD and
> SDIO as well while I'm doing this ?
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

I fail to see why you need to split MMC and SD. Could you elaborate why the controller won't work with MMC cards? I haven't seen any differences from SD.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
