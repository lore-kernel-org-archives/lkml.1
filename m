Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZGWRp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZGWRp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZGWRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZGWRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:45:55 -0400
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <1248354493.26273.2.camel@twins>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 19:45:10 +0200
Message-Id: <1248371110.4681.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 15:08 +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
> > This adds the support for kernel hardware breakpoints in perfcounter.
> > It is added as a new type of software counter and can be defined by
> > using the counter number 5 and by passsing the address of the
> > breakpoint to set through the config attribute.
> 
> Is there a limit to these hardware breakpoints? If so, the software
> counter model is not sufficient, since we assume we can always schedule
> all software counters. However if you were to add more counters than you
> have hardware breakpoints you're hosed.

Do the breakpoints work on virtual or physical addresses?

Also, do we have an 64bit architecture with split address-spaces?



