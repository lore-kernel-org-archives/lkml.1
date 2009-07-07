Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZGGI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZGGI3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZGGI3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:29:24 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:33884 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZGGI3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:29:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: add support to the 'perf' tool for
 tracepoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       rostedt@goodmis.org, fweisbec@gmail.com
In-Reply-To: <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com>
References: <cover.1246912068.git.jbaron@redhat.com>
	 <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 10:29:20 +0200
Message-Id: <1246955360.8143.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 17:12 -0400, Jason Baron wrote:
> Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
> implementation creates a 'for_each_subsystem' and 'for_each_event' for
> easy iteration over the tracepoints. The debugfs filesystem must be mounted
> at '/sys/kernel/debug'. We can add an optional search path in the future.

I don't have a single machine that has that mount point.


