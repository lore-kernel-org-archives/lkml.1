Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbXLHPjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbXLHPjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXLHPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:39:43 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34724 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXLHPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:39:43 -0500
Message-Id: <20071208153255.078261362@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 08 Dec 2007 10:32:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Instrumentation menu removal, against 2.6.24-rc4-mm1 (mmotm)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  8 Dec 2007 15:39:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This time I am taking no chance :

The instrumentation menu removal patchset here applies against 2.6.24-rc4-mm1
_and_ against mmotm (dated : stamp-2007-12-05-15-24) without problem.

We should hopefully be able to stop racing against other architecture specific
fixes done underneath. Please be aware that the following fix :

- fix-oprofile-configuration-breakage.patch

from MIPS did not show up in your mmotm tree. I guess you just sent it upstream
without keeping it in your own tree. I have applied the content of this fix in
my patchset (meaning : select HAVE_OPROFILE if !MIPS_MT_SMTC in
add-have-oprofile.patch), but I think you might have a reject if you still have
this fix-oprofile-configuration-breakage.patch in your local tree but not in
mmotm.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
