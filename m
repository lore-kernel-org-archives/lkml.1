Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXLFCNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXLFCNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbXLFCM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:12:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33923 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbXLFCM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:12:57 -0500
Message-Id: <20071206020758.035771102@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:07:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/7] Immediate Values (redux) for 2.6.24-rc4-git3
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:12:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the redux version of immediate values. It currently supports x86_32,
x86_64 and powerpc. The other architectures use a generic fallback (a simple
variable).

It depends on the text edit lock patches. It diminishes the impact of dormant
markers by providing a fast branch over a function call with a "load immediate"
instruction. It minimizes the d-cache hit.

This redux version it not reentrant wrt NMIs and MCEs. One must be cautious not
to use it in code paths reached by such execution contexts.

It could be interesting to queue this for 2.6.25.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
