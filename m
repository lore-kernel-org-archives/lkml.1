Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZGICqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZGICqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZGICqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:46:36 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53356 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbZGICqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h61cv82C5GT/dHO5YCYPJGCWlXib3XhjYS8hvHeXcYt4n/OpveaT7aHsEDqSzJ8CJj
         o3BNomMbWibaWHjHDtiRcs8sTaWC4bZFhpxIKd3IfIJGnT7hjDxbulU2ynSln/GSUmxz
         pF3QR6kDuU/++WeYlvmxTlzvAkWL+hA48P/bw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 0/2] tracing: convert some seq_print_ip_sym to %pf
Date: Thu,  9 Jul 2009 04:46:28 +0200
Message-Id: <1247107590-6428-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've replaced some seq_print_ip_sym by the %pf format.
I also wanted to convert seq_ip_print_sym() internals too, but
it relies on kprobes checks, so I'm not sure what to do there.

Thanks,
Frederic.

The following changes since commit ddc1637af217dbd8bc51f30e6d24e84476a869a6:
  Li Zefan (1):
        kmemtrace: Print binary output only if 'bin' option is set

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git ..BRANCH.NOT.VERIFIED..

Frederic Weisbecker (2):
      tracing/function-graph-tracer: Use the %pf format
      tracing/kmemtrace: Use the %pf format

 kernel/trace/kmemtrace.c             |   25 +++++--------------------
 kernel/trace/trace_functions_graph.c |   12 ++----------
 2 files changed, 7 insertions(+), 30 deletions(-)
