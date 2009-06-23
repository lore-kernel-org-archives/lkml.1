Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZFWNMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZFWNMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZFWNMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:12:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435AbZFWNMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:12:36 -0400
Message-ID: <4A40D499.6000805@redhat.com>
Date: Tue, 23 Jun 2009 09:11:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 4/7] kprobes: kprobes jump optimization
 core
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212319.5384.56039.stgit@localhost.localdomain> <20090623125806.GD8340@linux.vnet.ibm.com>
In-Reply-To: <20090623125806.GD8340@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
>> +	/* .insn_size is initialized later */
>> +	.nr_garbage = 0,
>> +};
> 
>> +#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
>> +	/* Init kprobe_optinsn_slots */
>> +	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
>> +#endif
>> +
> 
> What would be be the size of kprobe_optinsn_slots.insn_size if
> CONFIG_OPTPROBES is defined but __ARCH_WANT_KPROBES_INSN_SLOT is not
> defined? 

No problem. If __ARCH_WANT_KPROBES_INSN_SLOT is not defined,
kprobe_optinsn_slots doesn't exist.

Thank you,
> 
> -Srikar

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

