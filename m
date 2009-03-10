Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZCJQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZCJQK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZCJQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:10:10 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55541 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZCJQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:10:09 -0400
Date: Tue, 10 Mar 2009 17:10:03 +0100
From: Daniel Mack <daniel@caiaq.de>
To: SARDAR SHARIFF <sardar.mohd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libertas sdio wlan not working.
Message-ID: <20090310161003.GD10574@buzzloop.caiaq.de>
References: <8d99bcec0903100904q688bd823w5e40077d0b8fa82e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d99bcec0903100904q688bd823w5e40077d0b8fa82e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:34:53PM +0530, SARDAR SHARIFF wrote:
> I am using Linux 2.6.28. Im using marvell SD8686 wlan chip.
> 
> I downloaded the firmwares from marvell site.
> 
> I do the following:
> 
> 
> # insmod libertas.ko libertas_debug=0x5063a7
> # libertas_sdio helper_name=helper_sd.bin fw_name=sd8686.bin
> libertas_sdio: Libertas SDIO driver
> libertas_sdio: Copyright Pierre Ossman
> libertas_sdio mmc0:0001:1: firmware: requesting helper_sd.bin
> 
> libertas: can't load helper firmware
> libertas: failed to load helper firmware
> libertas_sdio: probe of mmc0:0001:1 failed with error -2

You need to have a userspace daemon running that serves the firmware to
the driver. This is typically done by udev, see 

	http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

And note that there is a dedicated mailing list for that devices:

	http://lists.infradead.org/mailman/listinfo/libertas-dev

Daniel

