Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXJaIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXJaIKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXJaIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:10:22 -0400
Received: from nic2.axis.se ([193.13.178.10]:45570 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbXJaIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:10:20 -0400
Date: Wed, 31 Oct 2007 09:10:07 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/16] CRIS architecture: Correct compile errors
Message-ID: <20071031081006.GV11960@axis.com>
References: <20071030093101.GI11960@axis.com> <20071030151410.e89dd01f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030151410.e89dd01f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 03:14:10PM -0700, Andrew Morton wrote:
> On Tue, 30 Oct 2007 10:31:01 +0100
> Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > - New file include/asm-cris/irq_regs.h.
> > - Change handling of registers for do_IRQ.
> > - Add GENERIC_HARDIRQS to Kconfig.
> > 
> > Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> > 
> > ---
> >  arch/cris/Kconfig                            |    4 ++++
> >  linux-2.6.23-mod/include/asm-cris/irq_regs.h |    1 +
> >  linux-2.6.23/arch/cris/kernel/irq.c          |    6 ++++--
> 
> include/asm-cris/irq_regs.h already exists so I dropped that part of your
> patch.
>
> All these changes will need retesting - the kernel has changed so much
> since 2.6.23 that they might not work correctly now.

Will do.

Thanks for all your time and work,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
