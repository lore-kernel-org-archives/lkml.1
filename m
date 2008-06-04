Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYFDPUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYFDPUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbYFDPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:20:07 -0400
Received: from [165.204.77.10] ([165.204.77.10]:44653 "EHLO erda.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbYFDPUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:20:06 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 11:20:06 EDT
Date: Wed, 4 Jun 2008 17:11:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] fix build bug in "x86: add PCI extended config space
	access for AMD Barcelona"
Message-ID: <20080604151131.GV23679@erda.amd.com>
References: <20080602143830.GA6835@elte.hu> <20080603173705.1790F8316@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603173705.1790F8316@erda.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 03.06.08 19:37:04, Robert Richter wrote:
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/powerpc/kernel/setup_64.c |    

This patch is wrong. It touches a different setup_64.c file. Sorry for
that, will send an update for tip/x86/cpu.

-Robert

>  arch/x86/kernel/cpu/amd.c      |    1 -
>  arch/x86/kernel/cpu/amd_64.c   |    1 +
>  arch/x86/kernel/setup.c        |    4 ++--
>  include/asm-x86/mmconfig.h     |    6 ------
>  5 files changed, 3 insertions(+), 11 deletions(-)
