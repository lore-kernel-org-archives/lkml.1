Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0AOKWS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622Ab0AOKWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:22:17 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39981 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0AOKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:22:16 -0500
Date: Fri, 15 Jan 2010 15:52:05 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100115102205.GE26396@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com> <1263467289.4244.288.camel@laptop> <1263498366.4875.25.camel@localhost.localdomain> <1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com> <1263549014.4244.374.camel@laptop> <20100115101056.GD26396@in.ibm.com> <1263550412.4244.375.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263550412.4244.375.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 11:13:32AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 15:40 +0530, Ananth N Mavinakayanahalli wrote:
> 
> > Ideas?
> 
> emulate the one instruction?

In kernel? Generically? Don't think its that easy for userspace --
you have the full gamut of instructions to emulate (fp, vector, etc);
further, the instruction could itself cause a page fault and the like.
