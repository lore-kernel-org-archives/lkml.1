Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZDHWog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZDHWog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZDHWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:44:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZDHWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:44:21 -0400
Date: Wed, 8 Apr 2009 18:44:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: RE: [PATCH] tracing/syscalls: use a dedicated file header
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.0904081842500.12259@gandalf.stny.rr.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com> <20090408184058.GB6017@nowhere>
 <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Luck, Tony wrote:

> > Tony, can you tell me if the patch below fixes your build?
> > Thanks!
> 
> Frederic,
> 
> Yes ... works great.  Builds are OK with and without CONFIG_IA32_SUPPORT.
> Kernel with CONFIG_IA32_SUPPORT=y boots fine and can run x86 (32-bit) binaries.
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Great! I'll pull it into my repo and get it ready to send to tip.

Is it OK to add a:

Reported-Tested-and-Acked-by: Tony Luck <tony.luck@intel.com>

-- Steve

