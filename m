Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYDVR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYDVR3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762392AbYDVR3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:29:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53777 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762596AbYDVR3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:29:06 -0400
Message-Id: <20080422172404.502954084@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:24:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [RFC patch 0/9] Stringify support commas
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 22 Apr 2008 17:28:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that the __stringify() macro does not support defines with commas.
This patchset change the macro so it takes variable arguments. All the
"-traditional" compilation flags are removed from all architectures which still
use it so the variadic macro is supported.

It is used by the x86 NMI-safe int3 and page fault patch.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
