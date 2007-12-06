Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbXLFDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbXLFDAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXLFDAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:07 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35377 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXLFDAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:03 -0500
Message-Id: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch-early-RFC 00/10] LTTng architecture dependent instrumentation
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the architecture dependent instrumentation for LTTng. Not all
architectures are supported, and some of them have missing instrumentation
points.

The most complete should be :
x86_32, x86_64, powerpc, mips and arm.

It depends on the kernel trace thread flag patchset.

It instruments :
- traps/faults
- system calls
- kernel thread creation
- IPC calls

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
