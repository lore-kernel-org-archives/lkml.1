Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322Ab0ARMYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0ARMYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095Ab0ARMYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:24:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:51757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0ARMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:24:37 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B545146.3080001@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <4B5325CF.5000001@redhat.com> <1263740593.557.20967.camel@twins>
	 <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop>
	 <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop>
	 <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop>
	 <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 13:24:05 +0100
Message-ID: <1263817445.4283.408.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 14:17 +0200, Avi Kivity wrote:
> On 01/18/2010 02:13 PM, Pekka Enberg wrote:
> > So how big chunks of the address space are we talking here for uprobes?
> >    
> 
> That's for the authors to answer, but at a guess, 32 bytes per probe 
> (largest x86 instruction is 15 bytes), so 32 MB will give you a million 
> probes.  That's a piece of cake for x86-64, probably harder to justify 
> for i386.

Yeah, I'm aware of people turning off address space randomization to
gain more virtual space on i386, I'm pretty sure those folks aren't
going to be happy if we shrink it.

Let alone them trying to probe their app.

