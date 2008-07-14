Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbYGNTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbYGNTUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYGNTUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:20:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYGNTUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:20:42 -0400
Date: Mon, 14 Jul 2008 21:18:09 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: johnpol@2ka.mipt.ru
cc: LKML <linux-kernel@vger.kernel.org>
Subject: hifn_795x in a MacMini?
Message-ID: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX191I357qRWvH4k6XUkQylMZgjRrD5f3OfFMy0f
 Iue9ZAHpdYrRRCOmCgr4mpgcfKXyWvcAAX0DAaXQYosbVAYztu
 HBSWNYTHzyKCzPXQfOkhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

while doing "make menuconfig" on a shiny new MacMini[0] I came across the 
option for the HIFN 795x crypto accelerator. I've set:

CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y

and after loading the module, dmesg shows:

   Driver for HIFN 795x crypto accelerator chip has been successfully registered.

Somehow this message sounds to me, as if this MacMini does have such a 
chip. This would be surprising, as I thought the chip is a highly 
specialized one, and expensive too. Also 
there's no ../devices/ symlink in /sys/bus/pci/drivers/hifn795x. Still, 
why would the driver load into the kernel when there's no such chip?

Thanks,
Christian.

[0] http://support.apple.com/specs/macmini/Mac_mini_Mid_2007.html
-- 
BOFH excuse #97:

Small animal kamikaze attack on power supplies
