Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbZKXPlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbZKXPlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbZKXPlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:41:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbZKXPlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:41:06 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 06/10] kprobes/x86: Cleanup save/restore 	registers
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
	<20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com>
	<20091124025115.GB6752@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 24 Nov 2009 10:40:24 -0500
In-Reply-To: <20091124025115.GB6752@nowhere> (Frederic Weisbecker's message of "Tue, 24 Nov 2009 03:51:17 +0100")
Message-ID: <y0mtywkx76f.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
>> +#define SAVE_REGS_STRING		\
>> +#define RESTORE_REGS_STRING		\
>
> BTW, do you really need to push/pop every registers
> before/after calling a probe handler?

It's part of the definition of a kprobe, that a populated
pt_regs* value is passed.  Clients can rely on that in order
to access registers etc.

- FChE
