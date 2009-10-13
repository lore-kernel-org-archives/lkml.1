Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbZJMULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbZJMULT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934282AbZJMULS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:18 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38748 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934283AbZJMULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:15 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 7
	times
Message-Id: <20091013200233.260324963@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Oct 2009 16:02:33 -0400
From: Christoph Lameter <cl@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC In-kernel benchmarks 0/3] Introduce in kernel benchmarks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel benchmarks are benchmarks that directly run in kernel space.

The test modules are regular kernel modules that can be loaded with

	modprobe slab_test

or so. 

The initialization function of the module will then run the test
and fail so that the module is not loaded. The output of the test
results will be written to the system log.

This is a rough draft. I have used these in the past to benchmark
page allocator, slab allocator and vmstat performance.

