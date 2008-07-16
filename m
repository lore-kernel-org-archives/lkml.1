Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYGPIph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYGPIph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYGPIp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:45:27 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:53464
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYGPIp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:45:26 -0400
Date: Wed, 16 Jul 2008 09:45:22 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [MIPS] fix missing prototypes in asm/fpu.h
Message-ID: <20080716084522.GB22957@linux-mips.org>
References: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi> <1216141052-28005-3-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216141052-28005-3-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:57:31PM +0300, Dmitri Vorobiev wrote:

> While building the Malta defconfig, sparse spat the following
> warnings:
> 
> >>>>>>>>>>>>>>>>>>
> arch/mips/math-emu/kernel_linkage.c:31:6: warning: symbol
> 'fpu_emulator_init_fpu' was not declared. Should it be static?
> 
> arch/mips/math-emu/kernel_linkage.c:54:5: warning: symbol
> 'fpu_emulator_save_context' was not declared. Should it be
> static?
> 
> arch/mips/math-emu/kernel_linkage.c:68:5: warning: symbol
> 'fpu_emulator_restore_context' was not declared. Should it be
> static?
> >>>>>>>>>>>>>>>>>>
> 
> This patch fixes these errors by adding the proper prototypes
> to the include/asm-mips/fpu.h header, and actually using this
> header in the sparse-spotted source file.

I'm not terribly fond of exporting these private prototypes by making
their prototypes widely available.  I see it's need to make sparse a more
productive tool, so I applied the patch though.

Thanks,

  Ralf
