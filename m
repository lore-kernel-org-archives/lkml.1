Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbXIXQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbXIXQz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXIXQzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:55:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41690 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXIXQzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:55:11 -0400
Message-Id: <20070924164950.006047409@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 24 Sep 2007 12:49:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [patch 0/7] Linux Kernel Markers (redux)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 24 Sep 2007 16:54:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Following Christoph Hellwig's suggestion, aiming at a Linux Kernel Markers
inclusion for 2.6.24, I made a simplified version of the Linux Kernel Markers.
There are no more dependencies on any other patchset.

The modification only involved turning the immediate values into static
variables and adapting the documentation accordingly. It will have a little more
data cache impact when disabled than the version based on the immediate values,
but it is far less complex.

Since things have not moved much in the markers area recently (most of the
concerns were about the immediate values), I expect it to be ready for 2.6.24.

It applies to 2.6.23-rc7-mm1

Patches apply in this order:

seq_file_sorted.patch
module.c-sort-module-list.patch
kconfig-instrumentation.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-instrumentation-menu.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
