Return-Path: <linux-kernel-owner+w=401wt.eu-S1767562AbXCIV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767562AbXCIV74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767560AbXCIV74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:59:56 -0500
Received: from gw.goop.org ([64.81.55.164]:36015 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767557AbXCIV7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:59:54 -0500
Message-ID: <45F1D8D7.9040207@goop.org>
Date: Fri, 09 Mar 2007 13:59:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu>
In-Reply-To: <20070309214704.GA20988@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i am worried whether /any/ future change to the upstream kernel's design 
> can be adopted via paravirt_ops, via the current VMI ABI. And by /any/ i 
> mean truly any. And whether that can be done is not a function of the 
> flexibility of paravirt_ops, it's a function of the flexibility of the 
> VMI ABI.

Come on. You're talking as if these changes can be made in a vacuum,
with no regard to any external constraints.  In reality, any such change
is limited by concerns like:

   1. does it make sense in terms of kernel design?
   2. can all the (real) architectures support it?
   3. does it make sense on real hardware?
   4. does it require massive kernel-wide changes, or does it have
      limited scope?
   5. etc, etc

Obviously one of the things to be considered among the many other issues
is "what effect does this have on the paravirt_ops interface?".

Now it may be that you've got a change that's absolutely great for
everyone, and the only blocker is that the FoobieVisor can't deal with
it.  OK, great, then you'd have a point.

But are you really saying that one of your handwavy proposals is just
fine on a pre-apic i486/mmu-less m68k/whatever, but can't be made to
work on a hypervisor?

Come up with a specific proposal, and we'll work out the details.

    J
