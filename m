Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbYBBUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbYBBUMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbYBBUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:12:12 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44488 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbYBBUML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:12:11 -0500
Message-Id: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/5] Instrumentation Menu Removal
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:12:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the updated instrumentation menu removal patches. They apply on top of
2.6.24-git12. I took tare of the underlying architecture changes that happened
recently (avr32 and arm especially).

Patch order :
# instrumentation menu removal
fix-arm-to-play-nicely-with-generic-instrumentation-menu.patch
create-arch-kconfig.patch
add-have-oprofile.patch
add-have-kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
