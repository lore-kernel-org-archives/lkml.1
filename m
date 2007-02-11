Return-Path: <linux-kernel-owner+w=401wt.eu-S1750788AbXBKTRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788AbXBKTRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXBKTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:17:51 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47853 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbXBKTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:17:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 00/10] atomic.h : standardizing atomic primitives
Date: Sun, 11 Feb 2007 14:17:38 -0500
Message-Id: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : standardizing atomic primitives

It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
unless. Therefore, principally 64 bits architectures are targeted by these
patches. It also adds the complete list of atomic operations on the atomic_long
type.

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

I haven't built cross-compilers for other architectures yet.

These patches apply on 2.6.20

Signed-off-by : Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

