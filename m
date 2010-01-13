Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345Ab0AMSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0AMSlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118Ab0AMSlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:41:44 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:33087 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab0AMSln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:41:43 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Nicholas Miell <nmiell@comcast.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100113182442.GA20704@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263358823.3874.10.camel@entropy>
	 <20100113053126.GC6781@linux.vnet.ibm.com>
	 <1263361196.3874.12.camel@entropy> <20100113143805.GC30875@Krystal>
	 <1263406071.3874.16.camel@entropy>  <20100113182442.GA20704@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 10:41:38 -0800
Message-ID: <1263408098.3874.19.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 13:24 -0500, Mathieu Desnoyers wrote:
> * Nicholas Miell (nmiell@comcast.net) wrote:
> 
> > The whole point of compat and incompat flags is that it allows new
> > applications to run on old kernels and either work or fail as
> > appropriate, depending on whether the new features they're using must be
> > implemented or can be silently ignored.
> 
> I see. Thanks for the explanation. Then the expedited flag should
> clearly be part of the mandatory flags.
> 
> Can you point me to other system calls that are doing this ?
> 
> Thanks,
> 
> Mathieu

Not off the top of my head, but I did steal the idea from the ext2/3/4
disk format.

-- 
Nicholas Miell <nmiell@comcast.net>

