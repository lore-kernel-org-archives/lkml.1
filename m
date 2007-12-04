Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXLDRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXLDRyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXLDRyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:54:14 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:50383 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXLDRyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:54:13 -0500
Message-Id: <20071204174358.271253130@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 04 Dec 2007 12:43:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 0/4] Instrumentation menu removal
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  4 Dec 2007 17:53:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the instrumentation menu removal patchset, updated to take care of
recent avr32 changes. It has been done on top of 2.6.24-rc4 with the following
patches applied :

[PATCH 1/2] [AVR32] Include instrumentation menu
[PATCH 2/2] [AVR32] Oprofile support

(which have been merged in the avr32 tree by Haavard)

Applying it in the current -mm after the "git-avr32.patch" in the following
order should work fine :

add-kconfig-to-arch.patch
add-have-oprofile.patch
add-have-kprobes.patch
move-kconfig-instrumentation-to-arch.patch

If you have any problem applying them, just tell me. I think there is no
difference between 2.6.24-rc4 + those two patches and your tree in that aspect,
but if there happen to be one, I'll get a -mm tree and do a clean patchset.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
