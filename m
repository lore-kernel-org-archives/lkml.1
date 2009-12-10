Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZLJAJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZLJAJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZLJAJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:09:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53982 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbZLJAJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:09:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH v4] [RFC] tracepoint: Add signal coredump tracepoint
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>
In-Reply-To: <20091209203835.12767.42778.stgit@dhcp-100-2-132.bos.redhat.com>
References: <4B1FCD74.8020302@redhat.com> <20091209203835.12767.42778.stgit@dhcp-100-2-132.bos.redhat.com>
Message-Id: <20091210090852.F4F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Dec 2009 09:09:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add signal coredump tracepoint which shows signal number,
> mm->flags, core file size limitation, the result of
> coredump, and core file name.
> 
> This tracepoint requirement comes mainly from the viewpoint of
> administrators. Since now we have introduced many coredump
> configurations (e.g. dumpable, coredump_filter, core_pattern,
> etc) and some of them can be modified by users, it will be hard
> to know what was actually dumped (or not dumped) after some
> problem happened on the system. For example, a process didn't
> generated core, coredump doesn't have some sections, etc.
> In those cases, the coredump tracepoint can help us to know
> why the core file is so big or small, or not generated, by
> recording all configurations for all processes on the system.
> That will reduce system-administration cost.
> 
> Changes in v4:
>  - Rename limit trace-argument to core_size_limit, because
>    of user friendly output.

Looks good to me.


