Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZGDAFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZGDAFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 20:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZGDAF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 20:05:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55624 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbZGDAF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 20:05:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19022.40132.606734.933933@cargo.ozlabs.ibm.com>
Date: Sat, 4 Jul 2009 10:05:24 +1000
From: Paul Mackerras <paulus@samba.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Move the 32-bit atomic64_t implementation to a .c file
In-Reply-To: <tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
	<tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar writes:

> Also, while at it, rename all uses of 'unsigned long long' to
> the much shorter u64.
> 
> This makes the appearance of the prototypes a lot nicer - and
> it also uncovered a few bugs where (yet unused) API variants
> had 'long' as their return type instead of u64.

Did you consider making atomic64_t a signed type on 32-bit x86 like it
is on all 64-bit platforms, and like atomic_t is everywhere?

Paul.
