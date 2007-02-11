Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbXBKTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbXBKTTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbXBKTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:18:25 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47870 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075AbXBKTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:18:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 00/10] local_t : adding and standardising local atomic primitives
Date: Sun, 11 Feb 2007 14:18:05 -0500
Message-Id: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

local_t : adding and standardising local atomic primitives

These patches extend and standardise local_t operations on each architectures,
allowing a rich set of atomic operations to be done on per-cpu data with
minimal performance impact. On architectures where there seems to be no
difference between the SMP and UP operation (same memory barriers, same
LOCKing), local.h simply includes asm-generic/local.h, which removes duplicated
code from the current kernel tree.

These patches apply on 2.6.20.
It depends on the patch "atomic.h : standardising atomic primitives"

These patches compile fine against :

arm
i686
ia64
m68k
mips
mipsel
x86_64
ppc 405
powerpc 970
s390
sparc
sparc64

Signed-off-by : Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

