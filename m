Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYBDGha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYBDGha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYBDGhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:37:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48096 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYBDGhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:37:20 -0500
Date: Mon, 4 Feb 2008 08:12:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell Leidich <rml@google.com>, Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, valdis.kletnieks@vt.edu,
       Tim Hockin <thockin@google.com>
Subject: Re: [PATCH] x86: Remove pt_regs arg from smp_thermal_interrupt
Message-ID: <20080204071204.GA571@one.firstfloor.org>
References: <20080108235212.GE2117@one.firstfloor.org> <3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com> <20080109023714.GK2117@one.firstfloor.org> <3f1a065b0801101821k71ea7523l5024f12abb50357f@mail.gmail.com> <3f1a065b0801171706o57ae5d6w8a986db508ddcee4@mail.gmail.com> <20080202161057.b240f443.akpm@linux-foundation.org> <1201998460.1844.32.camel@brick> <20080202163947.c66f6d19.akpm@linux-foundation.org> <1201999807.1844.34.camel@brick> <1202000513.1844.36.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202000513.1844.36.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 05:01:53PM -0800, Harvey Harrison wrote:
> The pt_regs arg is never used, make it agree with the other
> definitions of smp_thermal_interrupt.

They are all completely independent.

> 
> It doesn't look like smp_thermal_interrupt is even called on
> 32-bit...

It is called from a macro in include/asm-x86/mach-default/entry_arch.h

-Andi
