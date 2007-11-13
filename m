Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXKMO3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXKMO3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXKMO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:29:44 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34097 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXKMO3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:29:44 -0500
Message-Id: <20071113142609.103579906@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 09:26:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Instrumentation menu removal
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 14:29:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Following Linus's advice, this patch moves the content of "Instrumentation
Support" menu to "General Setup". The content is taken from
kernel/Kconfig.instrumentation and moved to init/Kconfig and arch/Kconfig.

This patchset applies on top of 2.6.24-rc2-git3 in the following order :

# instrumentation menu removal
#for -mm
add-kconfig-to-arch.patch
add-arch-supports-oprofile.patch
add-arch-supports-kprobes.patch
move-kconfig-instrumentation-to-arch.patch

This should be ready for -mm.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
