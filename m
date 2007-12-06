Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbXLFCVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbXLFCVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbXLFCU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:20:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:36594 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXLFCU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:20:57 -0500
Message-Id: <20071206021559.040218929@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:15:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/6] Linux Kernel Markers - Use Immediate Values Optimization
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:20:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Markers are meant to have a _very_ low impact on performance (even on
d-cache hits) when disabled. This is provided by the Immediate Values.

However, to be able to instrument code called from traps (NMI, MCE handler, all
code called by there functions and all traps that can be triggered by these),
the rock-solid implementation of the immediate values seems required. It,
however, comes at the cost of some added complexity.

This patch applies on 2.6.24-rc4-git3, after the 
Text Edit Lock
Immediate Values (redux)
Profiling Use Immediate Values

patchsets.

It could be interesting to queue this for 2.6.25 so we can also add basic kernel
instrumentation (patches follow).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
