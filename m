Return-Path: <linux-kernel-owner+w=401wt.eu-S934831AbXKPUGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbXKPUGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934552AbXKPUFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:05:17 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46485 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbXKPUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:05:15 -0500
Message-Id: <20071116200238.740495156@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:02:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Subject: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:05:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the updated immediate values following comments. The main changes :

- Declares a packed __immediate section to use less space. Declare the "size" as
  a char instead of an int.
- Simplified x86 immediate values update, spinning with IRQs disabled instead of
  using an lockless update algorithm. Is is simpler, but won't support NMI or
  MCE code updates.

This is submitted for another round of comments.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
