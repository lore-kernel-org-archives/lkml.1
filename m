Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbYEOP1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbYEOP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYEOP0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:26:55 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:41273 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYEOP0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:26:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18476.21589.315367.664174@stoffel.org>
Date: Thu, 15 May 2008 11:18:45 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: John Stoffel <john@stoffel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <482C5281.7020306@firstfloor.org>
References: <20080514174955.GA515@elte.hu>
	<6457.1210801515@vena.lwn.net>
	<87bq387cyn.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>
	<482B65FE.4040402@firstfloor.org>
	<18476.20788.142218.370584@stoffel.org>
	<482C5281.7020306@firstfloor.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:

Andi> John Stoffel wrote:
>>>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:
>> 
Andi> Linus Torvalds wrote:
>>>> On Thu, 15 May 2008, Andi Kleen wrote:
>>>>> The goal less being to get rid of BKL in old drivers, but not 
>>>>> requiring BKL in new drivers. Basically all BKL assumptions
>>>>> in interfaces really should go.
>>>> No, we really do want to get rid of BKL in old drivers too. Or at least in 
>>>> the interfaces.
>> 
Andi> In the interfaces definitely yes and all subsystems should have
Andi> their own lock_kernel calls, but why in the old drivers? For
Andi> those it's very unlikely they are used on any SMP system anyways
Andi> (e.g. anything depending on CONFIG_ISA) or if they do only on 2
Andi> CPU systems.
>> 
>> I'm still running an SMP server with ISA slots. 

Andi> I do too (although one CPU has died recently), but how many ISA
Andi> devices do you use in it? Mine used to have a ISA ISDN card, but
Andi> that was it and then no ISA anymore even though the slots are
Andi> still in there.

I must admit I used to have an ISA Cyclades 8 port serial card running
in there, but now it's all PCI stuff.  It only had one ISA slot.  So
yes, ISA SMP boxes are slowly dying, but they'll be around for a long
time to come.

Andi> Also on 2 CPU systems BKL is not that critical anyways. It only
Andi> starts to hurt on larger CPU counts.

True, but with the growing number of multicore systems, esp on
desktops, it's going to be an issue.  How will the BKL work on quad
core boxes?

I'm going to shutup now,  since I don't have the knowledge to really
contribute much to the discussion.  

John



