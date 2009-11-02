Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZKBErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZKBErT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZKBErS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:47:18 -0500
Received: from ozlabs.org ([203.10.76.45]:54925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZKBErR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:47:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19182.22063.788927.708332@cargo.ozlabs.ibm.com>
Date: Mon, 2 Nov 2009 14:46:55 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH 1/6] perf/core: Provide a kernel-internal interface to get to performance counters
In-Reply-To: <1257109753-6464-2-git-send-email-fweisbec@gmail.com>
References: <4AE55B1B.2030006@web.de>
	<1257109753-6464-2-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

>  /*
> + * perf_event_create_kernel_counter
> + * MUST be called from a kernel thread.

Why?  The reason for this requirement isn't obvious to me.  It would
be good to have the reason documented in the comment for the sake of
people modifying the code in future.

Paul.
