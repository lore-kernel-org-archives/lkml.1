Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXJ2O36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXJ2O36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXJ2O3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:29:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39762 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbXJ2O3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:29:41 -0400
Message-Id: <20071029142646.699058449@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 29 Oct 2007 10:26:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Subject: [patch 00/10] [PATCH] Create instrumentation/ kernel directory
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 29 Oct 2007 14:29:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since we already have the Instrumentation menu in
kernel/Kconfig.instrumentation and instrumentation code all over the
kernel tree:

arch/*/oprofile/*.c
kernel/kprobes.c
arch/*/kernel/kprobes.c
kernel/marker.c
kernel/profile.c
kernel/lockdep.c
vm/vmstat.c
block/blktrace.c

We could move them to

instrumentation/
arch/*/instrumentation/

Therefore, we could also move the kprobes and marker samples under

instrumentation/samples/

I submit these patches for review/comments, especially about kernel build
integration. instrumentation/ is currently a core-y and arch/*/instrumentation/
is a drivers-y because of oprofile.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
