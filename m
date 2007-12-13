Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbXLMK10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbXLMK10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbXLMK1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:27:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43201 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXLMK1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:27:17 -0500
Date: Thu, 13 Dec 2007 10:26:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Remy Bohmer <linux@bohmer.net>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert lazy irq disable for simple irqs
Message-ID: <20071213102618.GB18678@flint.arm.linux.org.uk>
References: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 03:20:10PM -0500, Steven Rostedt wrote:
> 
> [This patch *is* for mainline Linux]
> 
> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
> was implemented, and the simple irq handler had a masking set to it.
> 
> Remy Bohmer discovered that some devices in the ARM architecture
> would trigger the mask, but never unmask it. His patch to do the
> unmasking was questioned by Russell King about masking simple irqs
> to begin with. Looking further, it was discovered that the problems
> Remy was seeing was due to improper use of the simple handler by
> devices, and he later submitted patches to fix those. But the issue
> that was uncovered was that the simple handler should never mask.
> 
> This patch reverts the masking in the simple handler.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
