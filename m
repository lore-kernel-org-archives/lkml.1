Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZCXIEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZCXIEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZCXID4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:03:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZCXIDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:03:54 -0400
Message-ID: <49C893FC.9080905@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:04:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] blktrace: various cleanups and fixes, part 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first part is here:
	http://lkml.org/lkml/2009/3/19/475

And this is the 2nd part, and I still have some pending fixes..

Each patch is a small one, except the last one, which is still not big.

[PATCH 1/5] blktrace: mark ddir_act and what2act const
[PATCH 2/5] blktrace: fix wrong calculation of RWBS
[PATCH 3/5] blktrace: fix off-by-one bug
[PATCH 4/5] blktrace: fix t_error()
[PATCH 5/5] blktrace: print human-readable act_mask

 blktrace.c |  127 ++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 50 deletions(-)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
