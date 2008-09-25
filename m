Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYIYRsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYIYRsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYIYRse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:48:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIYRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:48:33 -0400
Date: Thu, 25 Sep 2008 13:48:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/2 v2] Unified trace buffer
In-Reply-To: <20080925173505.GD29392@Krystal>
Message-ID: <alpine.DEB.1.10.0809251347000.29802@gandalf.stny.rr.com>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org> <20080925173505.GD29392@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> 
> Is there a reason to use delta between events rather than simply write
> the 27 LSBs that I would have missed ?

One answer is that your counter wrap problem is extended.

That is, you have 27 bits of time between each event to not worry about
wraps. But if you go against the page itself, the last event on that page
is more likely to suffer.

-- Steve
