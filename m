Return-Path: <linux-kernel-owner+w=401wt.eu-S1765836AbZDHTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765836AbZDHTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbZDHTgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:36:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:47621 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZDHTgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,157,1239001200"; 
   d="scan'208";a="129406634"
From: "Luck, Tony" <tony.luck@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Date: Wed, 8 Apr 2009 12:36:33 -0700
Subject: RE: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Topic: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Index: Acm4eZNF8KGpaBaXQcGxbtalkXva4AABD7yQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
 <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
 <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
 <20090408184058.GB6017@nowhere>
In-Reply-To: <20090408184058.GB6017@nowhere>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, can you tell me if the patch below fixes your build?
> Thanks!

Frederic,

Yes ... works great.  Builds are OK with and without CONFIG_IA32_SUPPORT.
Kernel with CONFIG_IA32_SUPPORT=y boots fine and can run x86 (32-bit) binaries.

Acked-by: Tony Luck <tony.luck@intel.com>


Thanks for fixing this so quickly.

-Tony
