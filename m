Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998Ab0ATJ6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0ATJ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995Ab0ATJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:58:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0ATJ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:58:26 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B56D027.3010808@redhat.com>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com>  <4B545ACF.40203@cs.helsinki.fi>
	 <1263852957.2266.38.camel@localhost.localdomain>
	 <4B556855.6040800@redhat.com>
	 <1263923265.4998.28.camel@localhost.localdomain>
	 <4B56D027.3010808@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:57:52 +0100
Message-ID: <1263981472.4283.843.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 11:43 +0200, Avi Kivity wrote:
> 1. Write a trace entry into shared memory, trap into the kernel on overflow.
> 2. Trap if a condition is satisfied (fast watchpoint implementation).

So now you want to consume more of a process' address space to store
trace data as well? Not to mention that that process could wreck the
trace data rendering it utterly unreliable.

