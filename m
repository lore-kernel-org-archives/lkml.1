Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbZDAUPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbZDAUPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbZDAUPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:15:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50384 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbZDAUPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:15:00 -0400
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
From: Andi Kleen <andi@firstfloor.org>
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu>
	<49D37584.50208@redhat.com>
Date: Wed, 01 Apr 2009 22:14:54 +0200
In-Reply-To: <49D37584.50208@redhat.com> (Masami Hiramatsu's message of "Wed, 01 Apr 2009 10:09:08 -0400")
Message-ID: <873acsm8qp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:
>
> I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
> decoder :-) which has been made originally for uprobe andd kprobes
> jump-optimizer.
>
> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html

An alternative would be to adapt the x86 interpreter in KVM.
I thought for some time that that one should be available in 
a more generic form in a library.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
