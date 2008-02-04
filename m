Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYBDGB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYBDGB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYBDGBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:01:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:46825 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751259AbYBDGBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:01:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18K81ERMeYK222mvEv9u0PduSkHt6bo82/iqeAICA
	Pex1tA2aD/Ed8Z
Subject: Re: Latest -git ioremap error
From: Mike Galbraith <efault@gmx.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47A606B5.7090001@gmail.com>
References: <47A606B5.7090001@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 07:01:44 +0100
Message-Id: <1202104904.4233.9.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-03 at 14:23 -0400, Kevin Winchester wrote: 

> And git blame lead me to the following commit:
> 
> commit 266b9f8727976769e2ed2dad77ac9295f37e321e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jan 30 13:34:06 2008 +0100
> 
>     x86: fix ioremap RAM check
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Excellent <cancels bisect>.

[    9.524011] agpgart: Detected an Intel 865 Chipset.
[    9.526212] agpgart: unable to get memory for graphics translation table.
[    9.528521] agpgart: agp_backend_initialize() failed.
[    9.529318] agpgart-intel: probe of 0000:00:00.0 failed with error -12

Confirm, revert makes gart happy camper again.  Thanks.

	-Mike

