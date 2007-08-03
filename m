Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXHCSTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXHCSTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXHCSTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:19:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXHCSTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:19:41 -0400
Message-ID: <46B371AA.1040906@redhat.com>
Date: Fri, 03 Aug 2007 14:19:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Cal Peake <cp@absolutedigital.net>,
       Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>	 <46ACD8DB.2020108@googlemail.com>	 <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>	 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>	 <46B22BDA.8090604@redhat.com>	 <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>	 <46B23E08.4070106@redhat.com>	 <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>	 <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org> <1186156328.8105.72.camel@cunning>
In-Reply-To: <1186156328.8105.72.camel@cunning>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2007 11:52 AM, Ben Collins wrote:
> 
> This is the same problem I'm seeing (See Subject: Regression in 2.6.22,
> clock problems on Turion with 32-bit kernel).
> 
> This commit is what we bisected to:
> 
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
> 
>     [PATCH] clockevents: i386 drivers
> 

Yes, and the lapic timer apparently worked okay until then, right?

FWIW when you disable it this appears in the boot messages:

Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
 lapic is not functional.
Could not switch to high resolution mode on CPU 1

Yet "highres=off" does not fix the problem. Very strange...

