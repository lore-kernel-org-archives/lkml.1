Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0BSPSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0BSPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:18:46 -0500
Message-ID: <4B7EAB9E.2010509@redhat.com>
Date: Fri, 19 Feb 2010 13:17:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain> <20100219121734.GA8300@basil.fritz.box> <20100219124540.GC30243@aftab> <4B7E906D.8050501@linux.intel.com>
In-Reply-To: <4B7E906D.8050501@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, 

Andi Kleen wrote:
> Borislav,
>>>> year. You are refusing to work with other people on a well designed
>>
>> Sorry, but from our last discussion on attempting to work towards such
>> an infrastructure solution I got the same impression as Thomas and Ingo
>> that you're simply not willing to work together on getting a real thing
>> done. That's why I stopped bothering - it simply made no sense to me to
>> waste time in fruitless discussions.
> 
> Well I keep ignoring suggestions to put more stuff into EDAC,
> mostly because I think the EDAC design needs to be thrown out
> instead of extended. Are you referring to that?
> 
> My impression was that you  got to the same conclusion (at least
> for parts of current EDAC like the events) based on your earlier emails.
> 
> The current issue is less in enumeration/topology anyways but more
> in event handling I would say. In the end topology/enumeration is
> the easier part, and most of it is already working quite well.
> 
> I'm trying to do things step by step, including for short term
> problems extending current interfaces if possible and then longer
> term moving to new better interfaces.

Ingo and Thomas are right: we need to work together to improve the
error report, and this means that we shouldn't ignore putting more stuff
in EDAC.

EDAC is generic enough to work with different type of memory and memory
controllers, and to provide a consistent interface to describe it on a way
that userspace doesn't need to know what are the error registers at
the hardware, nor how to decode a "magic" error number into something
that has a meaning.

As Boris properly pointed, EDAC has space for improvements, and part of
the perf logic can be used as a start point to give some flash new ideas.

The main issue I see with MCE is at the interface level. I think if we
all cope together, we can converge into a proper interface that will
be accepted upstream.

-- 

Cheers,
Mauro
