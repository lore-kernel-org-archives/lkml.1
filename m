Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0CFNHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 08:07:48 -0500
Received: from mr011.hansenet.de ([85.183.254.144]:42629 "EHLO
	mr011.hansenet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0CFNHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 08:07:47 -0500
From: Thomas Koeller <thomas@koeller.dyndns.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: DMA using data buffer vmapped in kernel space
Date: Sat, 6 Mar 2010 14:07:12 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32.5; KDE/4.4.0; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201003042211.28569.thomas@koeller.dyndns.org> <20100304213634.GH13417@n2100.arm.linux.org.uk>
In-Reply-To: <20100304213634.GH13417@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003061407.12698.thomas@koeller.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. März 2010 22:36:34 schrieb Russell King - ARM Linux:
> Cache maintainence is done using virtual addresses for L1, and
> physical addresses for L2.  There's the need for virtual addresses
> to be translatable to physical addresses, which is only true for
> the kernel direct mapped region (pages between PAGE_OFFSET and
> high_memory).

Isn't the mapping created by vmap() sufficient for the virt/phys
translation? In which way is this case different from a buffer
passed in from user space, where the constituent pages are not
in the directly mapped kernel region either?

tk

