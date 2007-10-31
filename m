Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbXJaWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbXJaWm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXJaWmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51275 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbXJaWmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:16 -0400
Message-Id: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/28] cmpxchg_local and cmpxchg64_local patches, cleaned up
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a repost of those patches after running them through checkpatch.

I added a compile check to each architecture implementing cmpxchg64_local that
verifies if the argument size is 8 bytes.

Sorry about the coding style state in which those patches were : I tried to
follow the coding style of the existing header code, which is, to be polite,
disappointing.

I left the "volatile" in the function headers, since I do not want to take any
decision in that aspect without being fully aware of the consequences. If we
remove them in those functions, we should clean up the surrounding, already
existing, functions as well.

The only checkpatch errors left are related to inline assembly code, which does
not seem to follow the same rules.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
