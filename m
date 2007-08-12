Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbXHLPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbXHLPGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935560AbXHLPDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:03:25 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:65163 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765280AbXHLPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:03:24 -0400
Date: Sun, 12 Aug 2007 11:03:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 00/23] Atomic operations updates: add cmpxchg_local
Message-ID: <20070812150320.GA25080@Krystal>
References: <20070812145434.520271946@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070812145434.520271946@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:02:16 up 13 days, 15:21,  3 users,  load average: 4.59, 3.84, 3.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi Andrew,
> 
> I have been asked for a cmpxchg_local implementation by Christoph Lameter so he
> can use it to accelerate the slub allocator.
> 
> On some architectures, where cmpxchg is nothing more that a simple save/restore
> interrupts surrounding the cmpxchg non atomic ops, I remove the code and make
> them use the new "generic" version.
> 
> cmpxchg_local and cmpxchg64_local are made available on all architectures in
> these patches. They use the best primitive known, either an atomic operation or
> save/restore interrupts.
> 

Forgot to mention: it applies on top of 2.6.23-rc2-mm2

series file:

#
# cmpxchg_local and cmpxchg64_local standardization
#
i386-cmpxchg64-80386-80486-fallback.patch
#
add-cmpxchg-local-to-generic-for-up.patch
add-cmpxchg-local-to-arm.patch
add-cmpxchg-local-to-avr32.patch
add-cmpxchg-local-to-blackfin.patch
add-cmpxchg-local-to-cris.patch
add-cmpxchg-local-to-frv.patch
add-cmpxchg-local-to-h8300.patch
add-cmpxchg-local-to-ia64.patch
add-cmpxchg-local-to-m32r.patch
fix-m32r-__xchg.patch
local_t_m32r_optimized.patch
add-cmpxchg-local-to-m68k.patch
add-cmpxchg-local-to-m68knommu.patch
add-cmpxchg-local-to-parisc.patch
add-cmpxchg-local-to-ppc.patch
add-cmpxchg-local-to-s390.patch
add-cmpxchg-local-to-sh.patch
add-cmpxchg-local-to-sh64.patch
add-cmpxchg-local-to-sparc.patch
add-cmpxchg-local-to-sparc64.patch
add-cmpxchg-local-to-v850.patch
add-cmpxchg-local-to-xtensa.patch

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
