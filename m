Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbXJYUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbXJYUt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJYUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:49:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556AbXJYUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:49:17 -0400
Date: Thu, 25 Oct 2007 13:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: tglx@linutronix.de, nickpiggin@yahoo.com.au, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
Message-Id: <20071025134814.caced2e3.akpm@linux-foundation.org>
In-Reply-To: <20071025095540.827d4333.rdunlap@xenotime.net>
References: <20071023220959.a359d57d.rdunlap@xenotime.net>
	<200710241800.19764.nickpiggin@yahoo.com.au>
	<20071025093159.3ea69d03.rdunlap@xenotime.net>
	<alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain>
	<20071025095540.827d4333.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 09:55:40 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> -#define test_and_set_bit_lock test_and_set_bit
> +static __inline__ int test_and_set_bit_lock(int nr, volatile void * addr)

mutter.

ERROR: "foo * bar" should be "foo *bar"
#80: FILE: include/asm-x86/bitops_32.h:188:
+static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#80: FILE: include/asm-x86/bitops_32.h:188:
+static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)

ERROR: "foo * bar" should be "foo *bar"
#97: FILE: include/asm-x86/bitops_64.h:178:
+static __inline__ int test_and_set_bit_lock(int nr, volatile void * addr)

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#97: FILE: include/asm-x86/bitops_64.h:178:
+static __inline__ int test_and_set_bit_lock(int nr, volatile void * addr)

total: 2 errors, 2 warnings, 28 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

We might as well clean stuff up as we're churning the code.


Andy, I thought we were going to whine about __inline__ and __inline, too?
