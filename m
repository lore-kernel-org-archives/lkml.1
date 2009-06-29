Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZF2ROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZF2ROv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZF2ROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:14:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58190 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752303AbZF2ROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:14:43 -0400
Date: Mon, 29 Jun 2009 18:16:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629181603.079f32f1@lxorguk.ukuu.org.uk>
In-Reply-To: <200906291845.16335.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	<200906291822.18334.arnd@arndb.de>
	<20090629173121.768f2923@lxorguk.ukuu.org.uk>
	<200906291845.16335.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course that raises the question of whether smp_wmb() is too weak in case of
> !SMP or X86_PPRO_FENCE, but with the described scenario, I don't think
> it does.

I'm pretty sure it is for the Winchip -but we don't care as there are no
SMP ones. OTOH with DMA we do care

