Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZF2TJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZF2TJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZF2TJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:09:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55229 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752304AbZF2TJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:09:40 -0400
Date: Mon, 29 Jun 2009 20:10:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629201026.0f351013@lxorguk.ukuu.org.uk>
In-Reply-To: <20090629184706.GA9401@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	<200906291822.18334.arnd@arndb.de>
	<20090629173121.768f2923@lxorguk.ukuu.org.uk>
	<200906291845.16335.arnd@arndb.de>
	<20090629184706.GA9401@amd.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> X86_OOSTORE is defined for (MWINCHIP3D || MWINCHIPC6) && MTRR. I am not sure if
> these chips have sfence.
> It would also help to know what OOSTORE exactly means in the context of that
> chip.

Non uncached stores may be visible out of order on the bus.

Alan
