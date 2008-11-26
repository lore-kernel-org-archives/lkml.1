Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYKZM66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYKZM66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYKZM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:57:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46117 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYKZM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:57:54 -0500
Message-Id: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:42:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/17] Trace Clock v4
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Can we give it a try in -tip ?

This tracer clock infrastructure is rebased against current -tip and includes
the comments received in the previous posts. MIPS should be tested carefully,
because this patchset adds TSC synchronicity test to the architecture and I
don't have any MIPS board to test (I rely on the LTTng community for that).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
