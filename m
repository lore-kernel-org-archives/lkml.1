Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXJQVgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXJQVgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXJQVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:36:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668AbXJQVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:36:09 -0400
Date: Wed, 17 Oct 2007 14:35:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] Introduce "used_vectors" bitmap which can be used
 to reserve vectors.
Message-Id: <20071017143536.f4e7cba1.akpm@linux-foundation.org>
In-Reply-To: <200710172056.05123.rusty@rustcorp.com.au>
References: <200710172046.55454.rusty@rustcorp.com.au>
	<200710172052.47230.rusty@rustcorp.com.au>
	<200710172054.45652.rusty@rustcorp.com.au>
	<200710172056.05123.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 20:56:04 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> This simplifies the io_apic.c __assign_irq_vector() logic and removes
> the explicit SYSCALL_VECTOR check, and also allows for vectors to be
> reserved by other mechanisms (ie. lguest).

I already have this one as
x86_64-mm-introduce-used_vectors-bitmap-which-can-be-used-to-reserve-vectors.patch
- part of the firstfloor tree.

Thomas is going through those patches and is getting them merged up - a large
batch went through today.

So I assume he'll me merging this patch via that route, unless he has
decided to skip it for some reason.

Either way, I guess I'll hang onto the firstfloor.org leftovers until each
one has some sort of definite disposition.

