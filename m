Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0CCAIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:08:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab0CCAIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:08:14 -0500
Date: Tue, 2 Mar 2010 16:07:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 2/3] arm: Convert arm to arch_gettimeoffset()
Message-Id: <20100302160724.8544ba53.akpm@linux-foundation.org>
In-Reply-To: <1267484054.4216.94.camel@localhost.localdomain>
References: <1267483897.4216.91.camel@localhost.localdomain>
	<1267484054.4216.94.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Mar 2010 14:54:14 -0800
john stultz <johnstul@us.ibm.com> wrote:

> This patch converts arm to use GENERIC_TIME via the arch_getoffset()
> infrastructure, reducing the amount of arch specific code we need to
> maintain.

It runs afoul of the pending changes in linux-next:

patching file arch/arm/Kconfig
Hunk #3 FAILED at 240.
Hunk #4 FAILED at 250.
Hunk #5 FAILED at 262.
Hunk #6 succeeded at 293 (offset 21 lines).
Hunk #7 succeeded at 301 (offset 21 lines).
Hunk #8 succeeded at 310 (offset 21 lines).
Hunk #9 succeeded at 319 (offset 21 lines).
Hunk #10 succeeded at 336 (offset 21 lines).
Hunk #11 FAILED at 344.
Hunk #12 succeeded at 364 (offset 20 lines).
Hunk #13 succeeded at 375 (offset 20 lines).
Hunk #14 succeeded at 382 (offset 20 lines).
Hunk #15 succeeded at 393 (offset 20 lines).
Hunk #16 succeeded at 407 (offset 20 lines).
Hunk #17 succeeded at 419 (offset 20 lines).
Hunk #18 succeeded at 432 (offset 20 lines).
Hunk #19 succeeded at 441 (offset 20 lines).
Hunk #20 succeeded at 450 (offset 20 lines).
Hunk #21 succeeded at 459 (offset 20 lines).
Hunk #22 succeeded at 468 (offset 20 lines).
Hunk #23 succeeded at 484 (offset 20 lines).
Hunk #24 succeeded at 495 (offset 20 lines).
Hunk #25 succeeded at 504 (offset 20 lines).
Hunk #26 succeeded at 515 (offset 20 lines).
Hunk #27 succeeded at 528 (offset 20 lines).
Hunk #28 succeeded at 542 (offset 20 lines).
Hunk #29 succeeded at 553 (offset 20 lines).
Hunk #30 succeeded at 562 (offset 20 lines).
Hunk #31 succeeded at 577 (offset 20 lines).
Hunk #32 succeeded at 601 (offset 20 lines).
Hunk #33 succeeded at 614 (offset 20 lines).
Hunk #34 FAILED at 623.
Hunk #35 succeeded at 646 (offset 26 lines).
Hunk #36 succeeded at 660 (offset 26 lines).
Hunk #37 succeeded at 672 (offset 26 lines).
Hunk #38 FAILED at 682.
Hunk #39 succeeded at 743 (offset 66 lines).
Hunk #40 succeeded at 753 (offset 66 lines).
Hunk #41 succeeded at 767 (offset 66 lines).
Hunk #42 succeeded at 777 (offset 66 lines).
Hunk #43 succeeded at 795 (offset 66 lines).
Hunk #44 succeeded at 806 (offset 66 lines).
Hunk #45 succeeded at 815 (offset 66 lines).
Hunk #46 succeeded at 944 (offset 73 lines).
6 out of 46 hunks FAILED -- saving rejects to file arch/arm/Kconfig.rej
