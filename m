Return-Path: <linux-kernel-owner+w=401wt.eu-S939002AbXHIMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939002AbXHIMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbXHIMEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:04:07 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51104 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682AbXHIMEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:04:06 -0400
Date: Thu, 9 Aug 2007 14:03:59 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2: MMC_ARMMMCI compile error
Message-ID: <20070809140359.4bd1778a@poseidon.drzeus.cx>
In-Reply-To: <20070808213114.GK6997@stusta.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<20070808213114.GK6997@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 23:31:14 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> 
> CONFIG_MMC_ARMMMCI=m/y results in the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/mmc/host/mmci.o
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm2/drivers/mmc/host/mmci.c:
> In function
> 'mmci_request': /home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm2/drivers/mmc/host/mmci.c:398:
> error: implicit declaration of function 'mmc_end_request' make[4]:
> *** [drivers/mmc/host/mmci.o] Error 1
> 

Thanks. That wasn't the only bug in there. Hopefully fixed now.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
