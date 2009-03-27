Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZC0FjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZC0FjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZC0FjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:39:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZC0FjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:39:09 -0400
Message-ID: <49CC6691.7050103@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 13:39:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/7] blktrace: last round of fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last round of fixes for blktrace, I hope.  :) 

Changelog v1 -> v2:
  - fix a bug in "blktrace: make classic output more classic",
    and rebase other patches.
  - re-order patches.
  - a new patch for filtering BLK_TN_MESSAGE


[PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
[PATCH v2 2/6] blktrace: make classic output more classic
[PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
[PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace
[PATCH v2 5/6] blktrace: extract duplidate code
[PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly
---
 blktrace.c     |  188 +++++++++++++++++++++++++++++++++------------------------
 trace_output.c |    6 -
 trace_output.h |    5 -
 3 files changed, 117 insertions(+), 82 deletions(-)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>



