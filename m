Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0AOJDo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206Ab0AOJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:03:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:51324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0AOJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:03:41 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263498366.4875.25.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 10:02:55 +0100
Message-ID: <1263546175.4244.342.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> 
> +Instruction copies to be single-stepped are stored in a per-process
> +"single-step out of line (XOL) area," which is a little VM area
> +created by Uprobes in each probed process's address space.

I think tinkering with the probed process's address space is a no-no.
Have you ran this by the linux mm folks? I'd be inclined to NAK this
straight out.

