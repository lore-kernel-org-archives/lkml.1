Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbXHBU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbXHBU1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbXHBU1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:27:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbXHBU1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:27:38 -0400
Message-ID: <46B23E08.4070106@redhat.com>
Date: Thu, 02 Aug 2007 16:26:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Cal Peake <cp@absolutedigital.net>
CC: Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com> <46ACD8DB.2020108@googlemail.com> <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net> <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net> <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
In-Reply-To: <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2007 03:42 PM, Cal Peake wrote:
> On Thu, 2 Aug 2007, Chuck Ebbert wrote:
> 
>> On 08/02/2007 01:50 PM, Cal Peake wrote:
>>> This problem seems to be getting worse. With the latest linus tree, after 
>>> the initial hang where the power button is needed to bring the system back 
>>> to life, the boot process slows to a crawl.
>>>
>>> Although if I repeatedly press the shift key it'll help move things along. 
>>> I'm guessing the keyboard interrupt firing off is doing something to help 
>>> it. The system seems OK though after booting is finished.
>>>
>>> Upon shutdown it actually stalls out without help from the shift key.
>>>
>>> Any thoughts on this, or tips to help debug it further?
>> Try the 'nolapic_timer' option.
> 
> Ah, thank you Chuck! This looks to have fixed the stalling/hanging 
> problems I was having.
> 
> Now I'm wondering if arch/i386/kernel/cpu/amd.c:amd_apic_timer_broken() 
> can (or needs to) be updated for this particular CPU revision.

What does your /proc/cpuinfo say?

