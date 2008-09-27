Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYI0UH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYI0UH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYI0UHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:07:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47191 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYI0UHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:07:16 -0400
Message-ID: <8f3aa8d60809271307o1c306eccm5571670090218ab9@mail.gmail.com>
Date: Sat, 27 Sep 2008 13:07:14 -0700
From: "Martin Bligh" <mbligh@mbligh.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH v9] Unified trace buffer
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Martin Bligh" <mbligh@google.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
In-Reply-To: <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080925185236.244343232@goodmis.org>
	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
	 <20080927183912.GA13685@elte.hu>
	 <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com>
	 <20080927194105.GF18619@elte.hu>
	 <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> that's even worse i think :-/ And this isnt bikeshed-painting really,
>> the RNGBF_ name hurts my eyes and RB_ is definitely confusing to read.
>> (as the rbtree constants are in capitals as well and similarly named)
>>
>>  RING_TYPE_PADDING
>>
>> or:
>>
>>  RINGBUF_TYPE_PADDING
>>
>> yes, it's longer, but still, saner.
>
> I don't mind the extra typing, it is just a bit more difficult to keep in
> the 80 character line limit.

Would using tb_ (trace buffer) rather than rb_ help ?
