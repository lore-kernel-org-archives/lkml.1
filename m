Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbZC0CTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbZC0CTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbZC0CS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:18:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55511 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757284AbZC0CS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:18:58 -0400
Message-ID: <49CC37AA.3060908@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 10:19:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] blktrace: last round of fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last round of fixes for blktrace, I hope. :)

[PATCH 1/6] blktrace: make classic output more classic
[PATCH 2/6] blktrace: fix blk_probes_ref chaos
[PATCH 3/6] blktrace: fix memory leak when freeing struct blk_io_trace
[PATCH 4/6] trace: make 'mem' argument of trace_seq_putmem() const
[PATCH 5/6] blktrace: extract duplidate code
[PATCH 6/6] blktrace: print out BLK_TN_MESSAGE properly
---
 blktrace.c     |  188 +++++++++++++++++++++++++++++++++------------------------
 trace_output.c |    6 -
 trace_output.h |    5 -
 3 files changed, 117 insertions(+), 82 deletions(-)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
