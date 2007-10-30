Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXJ3WPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXJ3WPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXJ3WOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:14:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbXJ3WON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:14:13 -0400
Date: Tue, 30 Oct 2007 15:14:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151410.e89dd01f.akpm@linux-foundation.org>
In-Reply-To: <20071030093101.GI11960@axis.com>
References: <20071030093101.GI11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:31:01 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> - New file include/asm-cris/irq_regs.h.
> - Change handling of registers for do_IRQ.
> - Add GENERIC_HARDIRQS to Kconfig.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  arch/cris/Kconfig                            |    4 ++++
>  linux-2.6.23-mod/include/asm-cris/irq_regs.h |    1 +
>  linux-2.6.23/arch/cris/kernel/irq.c          |    6 ++++--

include/asm-cris/irq_regs.h already exists so I dropped that part of your
patch.

All these changes will need retesting - the kernel has changed so much
since 2.6.23 that they might not work correctly now.

