Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461Ab0ARNF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0ARNF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244Ab0ARNF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:05:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0ARNF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:05:27 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B5459CA.9060603@redhat.com>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 14:05:10 +0100
Message-ID: <1263819910.4283.478.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 14:53 +0200, Avi Kivity wrote:
> On 01/18/2010 02:51 PM, Pekka Enberg wrote:
> >
> > And how many probes do we expected to be live at the same time in
> > real-world scenarios? I guess Avi's "one million" is more than enough?
> >    
> 
> I don't think a user will ever come close to a million, but we can 
> expect some inflation from inlined functions (I don't know if uprobes 
> replicates such probes, but if it doesn't, it should).

That's up to the userspace creating the probes but yes, agreed.

