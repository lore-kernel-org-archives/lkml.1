Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0BVXPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:15:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0BVXPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:15:04 -0500
Message-ID: <4B830FDB.7010202@redhat.com>
Date: Mon, 22 Feb 2010 18:14:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
CC: Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v10 0/9] kprobes: Kprobes jump optimization support
References: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hi Ingo,
> 
> Here are the patchset of the kprobes jump optimization v10
> (a.k.a. Djprobe). This version just updated a document,
> and applicable for 2.6.33-rc8-tip.

BTW, this optimization is automatically done in kprobes.
(no other tools/changes are required for it)
This means all users including perf-probe have a benefit
from this feature just by configuring CONFIG_OPTPROBES=y :)
So it's a part of perf-probe/kprobe-tracer enhancement, IMHO.

Thank you,
-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
