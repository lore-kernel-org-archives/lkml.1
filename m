Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXH3KBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXH3KBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXH3KBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:01:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57284 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753570AbXH3KBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:01:30 -0400
Date: Thu, 30 Aug 2007 11:09:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Markus Dahms <mad@automagically.de>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ALSA compilation on Sparc32
Message-ID: <20070830110939.23146ea3@the-village.bc.nu>
In-Reply-To: <20070830092604.GA17041@vimes.madsworld.lan>
References: <20070830092604.GA17041@vimes.madsworld.lan>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 11:26:04 +0200
Markus Dahms <mad@automagically.de> wrote:

> The dma_alloc_coherent and dma_free_coherent function seem to be not
> available on sparc(32) architecture. It is not used by SBus sound
> drivers, so it's disabled via #ifndef for CONFIG_SPARC32.

It would probably look a lot cleaner if you either provided dummy
dma_alloc_coherent/free coherent inlines for SPARC32, fixed it (if
sparc32 can do coherent DMA) or if you must ifdef it provide dummy
functions in the memalloc code so its a single ifdef

