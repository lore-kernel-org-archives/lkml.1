Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXGCRWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXGCRWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760354AbXGCRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:21:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55847 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273AbXGCRVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:21:43 -0400
Message-Id: <20070703170843.204442953@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 13:08:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 17:20:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This updated version of the Linux Kernel Markers mostly adds a unique 16 bits
per marker ID and a per-probe marker group.

Christoph, I think the only concern that I do not plan to address immediately is
to provide a complet in-kernel user of the markers (blktrace patch does not
actually use the markers full potential). I have external patches that provides
that, but I don't want to send too much patches at once. Between providing a
complete marker/tracer stack and sending small incremental patches, I think the
latter is the choice the better suited. This is however an uneasy problem, which
looks very much like the chicken and egg problem. :)

If you have concerns with what I recently added to the markers, or if you still
strongly feel that I must also send the following patches right away, please let
me know.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
