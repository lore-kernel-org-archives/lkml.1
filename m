Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXCHXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXCHXjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXCHXjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:39:08 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52294 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161217AbXCHXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:39:06 -0500
Message-ID: <45F09E99.6000602@vmware.com>
Date: Thu, 08 Mar 2007 15:39:05 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <20070308224223.GD30113@elte.hu>
In-Reply-To: <20070308224223.GD30113@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> [...]  So it is a little late to tell us - "redesign your hypervisor, 
>> or else.."
>>     
>
> is this how long the "paravirt_ops hides all the details and the VMI 
> hypervisor ABI will never hinder Linux" sham lasted? Now that your stuff 
> is upstream barely 2 weeks you say that it needs a redesign of your 
> hypervisor to implement our suggestions? And your argument is: "oops, 
> we've got product plans, too late for that, sorry"?
>   

Clever way to misconstrue my point.  If I took the same tack with your 
espousal of hypervisor API philosophy and cited all the different 
opinions you've been spewing lately, I think we could probably make a 
strong argument that VMI should be the model used by all hypervisors and 
should support any frankenstein combination of virtual and traditional 
hardware, because it should work for all types of emulated silicon.

We don't need to redesign our hypervisor, but that is what a lot of 
people seem to want us to do.  And there is no reason nor is there time 
to do it.

> _we_ have to live with that mess for years, and part of our job is to 
> say 'NO' when we see mess coming up. And no, it's not our job to solve 
> it for you.

You don't   have to live with any mess.  If you change the kernel 
interfaces to clockevents to pass around XML based time encodings, or 
you completely rewrite the way APIC and IO-APIC interact with the 
interrupt subsystem, and this breaks our code, there is a shared 
responsibility to make things work, but we are actively maintaining the 
code and will continue to do so.  If at some point we don't, the code 
gets marked broken, and eventually deprecated.  And there is no mess for 
you to live with.

We just want a way to work with the in-kernel interfaces that is blessed 
and correct, and that is where you could give feedback, but instead you 
refuse to delve into technical details of our proposed solutions, while 
blasting and breaking all of our current code.   We're trying to do the 
right thing and get feedback and design this thing right with the 
community, and all you can offer is violence and non-productive 
criticism - "nack, this is crap" is not a good answer.

So we'll just randomly try all of the proposed solutions until we find 
one that isn't nacked, which is a waste of everybody's time, but 
hopefully finds the correct solution.  Or you could just look at the 
solutions I proposed and tell me which ones you think are best.

Zach
