Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZFWM6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZFWM6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZFWM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:58:10 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:55079 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZFWM6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:58:09 -0400
Date: Tue, 23 Jun 2009 18:28:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20090623125806.GD8340@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212319.5384.56039.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622212319.5384.56039.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* .insn_size is initialized later */
> +	.nr_garbage = 0,
> +};

> 
> +#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
> +	/* Init kprobe_optinsn_slots */
> +	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
> +#endif
> +

What would be be the size of kprobe_optinsn_slots.insn_size if
CONFIG_OPTPROBES is defined but __ARCH_WANT_KPROBES_INSN_SLOT is not
defined? 

-Srikar
