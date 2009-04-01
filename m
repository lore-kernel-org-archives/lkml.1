Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbZDAWOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbZDAWOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZDAWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:13:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbZDAWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:13:58 -0400
Date: Thu, 2 Apr 2009 00:15:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
Message-ID: <20090401221540.GX11935@one.firstfloor.org>
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu> <49D37584.50208@redhat.com> <873acsm8qp.fsf@basil.nowhere.org> <49D3D3B4.4060702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3D3B4.4060702@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 04:51:00PM -0400, Masami Hiramatsu wrote:
> Andi Kleen wrote:
> > Masami Hiramatsu <mhiramat@redhat.com> writes:
> >> I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
> >> decoder :-) which has been made originally for uprobe andd kprobes
> >> jump-optimizer.
> >>
> >> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> > 
> > An alternative would be to adapt the x86 interpreter in KVM.
> > I thought for some time that that one should be available in 
> > a more generic form in a library.
> 
> As far as I can see, KVM's instruction emulator is incomplete

That's fine for you -- you only care about a subset of instructions
anyways, don't you?

> (it doesn't cover all instructions...) and aims to emulate
> instructions, not to analyze (so I couldn't relay on it).

You can use it to analyze, just plug in the right callbacks that
do nothing. I looked at it some time ago for doing instruction
length checking for some application, but that application
then disappeared. The main obstacle with making it a library 
is that some KVM specific dependencies have crept in that would
need to be abstracted again, but I don't think it would need a lot of 
effort,

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
