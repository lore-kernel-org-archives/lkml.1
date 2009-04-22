Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZDVUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZDVUsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZDVUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:47:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51895 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbZDVUra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:47:30 -0400
Message-Id: <20090422201852.092307236@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 22 Apr 2009 16:18:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/2] Fixing AMD cmpxchg "missing lfence" mess
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 22 Apr 2009 20:46:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've prepared this patch, which applies on 2.6.30-rc2. It's an attempt to make
the kernel work around AMD's bug regarding missing lfence in the sync; cmpxchg
instruction.

The first patch is a alternative.h cleanup, and the second patch implements the
fixup using alternatives.

Indeed, this only makes the kernel aware of the bug. Userland will still have to
be taught to use such lfence too.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
