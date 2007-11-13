Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbXKMSnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbXKMSnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbXKMSnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:07 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52224 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbXKMSnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:05 -0500
Message-Id: <20071113183923.190808360@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:39:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Linux Kernel Markers Fixes
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:42:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are some fixes for the Linux Kernel Markers present in 2.6.24-rc2-git3.
There is a code path (module load) that may update markers without holding the
markers mutex, si I fixed that. The rest is just an tiny documentation
improvement.

The patchset applies on top of 2.6.24-rc2-git3 in this order:

#for -mm
markers-fix-markers-mutex-upon-module-load.patch
markers-document-markers-format-strings.patch
markers-fix-example-format-string.patch

They should be merged in mainline before 2.6.24 final (especially the mutex
fix).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
