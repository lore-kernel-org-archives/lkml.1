Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbYBOXAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbYBOXAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYBOXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:00:19 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:37284 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYBOXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:00:15 -0500
Message-ID: <47B61955.5020100@tiscali.nl>
Date: Fri, 15 Feb 2008 23:59:33 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <47B32510.20200@tiscali.nl> <alpine.LFD.1.00.0802131002250.2920@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802131002250.2920@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 13 Feb 2008, Roel Kluin wrote:
>> In nature there is a lot of duplication: several copies of genes can exist
>> and different copies may have a distinct evolution.
> 
> This is true of very complex animals, but much less so when looking at 
> things like bacteria (and arguably, any current sw project is closer to 
> bacteria in complexity than anything mammalian).
> 
> In bacteria (and viruses), duplication of DNA/RNA is a big cost of living 
> in general, and as a result there is *much* less junk DNA. So in an 
> evolutionary sense, it's much closer to what the kernel should have (with 
> occasional duplication of code and interfaces to allow new functionality, 
> but rather aggressive pruning of the excess baggage).

I like the comparison, and while I wrote my comment I have to admit I was
also thinking of bacteria and virusses as an exception: There the speed of
replication can be an important factor for survival. Less DNA means faster
replication and therefore the pressure is on removal of junk DNA. It can
be disputed however that removal of 'junk sourcecode' is a survival factor
for the linux kernel but the benefit may be disputable as well.

> In other words, all of these choices are a matter of "balance". In some 
> areas, excess code is not a sufficient downside, and we keep even broken 
> source code around with no actual function, "just because" (or rather, 
> because the cost of carrying it around is so small that nobody cares). 
> 
> That's true in the kernel as in biology: check out not just deprecated 
> code, but the drivers and other odds-and-ends that are explicitly marked 
> as non-coding DNA (we just happen to call them BROKEN in our Kconfig).
> 
> 			Linus

Maybe we can elaborate a bit on this comparison, just for fun:

I think not the linux kernel alone, but rather the entire Linux OS could
be compared with a cell. The kernel source encodes vital software parts
including the interactions with hardware - the environment for the
computer. Gcc can be compared with the (transcription and) translation
machinery. DNA can be seen as a language that encodes proteins, with
biological functions: Some are vital, including ones that allow
interactions with the environment: The cellular environment is beyond
the membrane. Interactions occur through membrane receptors, channels,
etc.

Interaction between proteins can be compared with functions selectively
calling other functions. Activation of certain proteins can cause a
cascade of protein interactions, comparable with function calls in a
loop: the activated protein activates particular protein(s) several
times. Some proteins influence intracellular messengers: cellular
global variables.

Transmembrane receptors responding to extracellular signals transmit
this through conformational changes across the membrane to the
intracellular region: These structural changes may allow interactions
with new proteins. Maybe comparable with a combination of hardware
interrupts, signals and the userspace?

The response to extracellular signals often depends on several
sequential interactions between proteins. This provides a protective
layer that can be compared with the kernelspace layer. This is where 
the comparison probably becomes too biased to continue.
