Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZCBVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZCBVDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZCBVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:03:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53514 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZCBVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:03:21 -0500
Date: Mon, 2 Mar 2009 21:01:58 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Message-ID: <20090302210158.GA18479@flint.arm.linux.org.uk>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop> <20090302144303.GA30136@elte.hu> <20090302154748.GB14217@parisc-linux.org> <1236009588.5330.729.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236009588.5330.729.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 04:59:48PM +0100, Peter Zijlstra wrote:
> The idea is to mandate IRQF_DISABLED for everybody, and since it doesn't
> do any good to have it a flag if you have it always enabled, remove
> it ;-)

Bad.  Very bad.

So, when I use PIO IDE on embedded platforms, I have to have all other
interrupts locked out for things like serial ports, network interfaces
with small packet buffers, etc and I can't specify IRQF_DISABLE on
such network interfaces anymore?

No, this is a step backwards.  Please don't go there.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
