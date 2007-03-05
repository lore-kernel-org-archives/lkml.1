Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbXCEWIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbXCEWIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXCEWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:08:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:13990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXCEWIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,251,1170662400"; 
   d="scan'208"; a="206896175:sNHT21719194"
Message-ID: <45EC94CB.6080903@intel.com>
Date: Mon, 05 Mar 2007 14:08:11 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_jmicron: remove spurious #endif
References: <20070303201541.GA22621@dreamland.darkstar.lan>
In-Reply-To: <20070303201541.GA22621@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2007 22:08:12.0416 (UTC) FILETIME=[C417E800:01C75F72]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> Hello,
> commit 438ac6d5e3f8106a6bd1a5682c508d660294a85d causes a build failure:
> 
>   CC      drivers/ata/pata_jmicron.o
>   /home/kronos/src/linux-2.6.git/drivers/ata/pata_jmicron.c:247:2: error: #endif without #if
>   make[3]: *** [drivers/ata/pata_jmicron.o] Error 1
> 
> Remove a spurious #endif in pata_jmicron driver.

I think the problem is that Tejun forgot to *add* a #ifdef CONFIG_PM instead.

Cheers,

Auke
