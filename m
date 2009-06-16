Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbZFPRtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbZFPRtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZFPRs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:48:58 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40220 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFPRs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:48:57 -0400
Message-ID: <4A37DB0F.7060801@freescale.com>
Date: Tue, 16 Jun 2009 12:49:03 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@lists.ozlabs.org, Chris Pringle <chris.pringle@oxtel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com> <4A37CF02.5080906@oxtel.com> <4A37D073.6020802@freescale.com> <200906161943.38764.arnd@arndb.de>
In-Reply-To: <200906161943.38764.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 16 June 2009, Scott Wood wrote:
>> Chris Pringle wrote:
>>> Ah right - that would explain what we're seeing then... Doh. Thought I 
>>> might have been onto something then. Is there any way to force a cache 
>>> flush? That'd at least prove it was a caching issue if it resolved the 
>>> problem.
>> You could enable CONFIG_NOT_COHERENT_CACHE.
> 
> If the whole system is noncoherent, that is the right solution.

I meant it more as a test than a permanent solution...

> If the
> device is the only one, you can also use dma_alloc_noncoherent() and
> flush explicitly with dma_cache_sync().

I don't see how that would help -- aren't those also controlled by 
CONFIG_NOT_COHERENT_CACHE?

-Scott
