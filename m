Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbZGLGcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbZGLGcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 02:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZGLGbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 02:31:55 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:50490 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZGLGbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 02:31:55 -0400
Date: Sun, 12 Jul 2009 07:31:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic - set cpu_has_apic for discrete apic
In-Reply-To: <20090712055200.GB4782@lenovo>
Message-ID: <alpine.LFD.2.00.0907120709220.13862@eddie.linux-mips.org>
References: <20090711212929.GG5325@lenovo> <alpine.LFD.2.00.0907120141020.13862@eddie.linux-mips.org> <20090712055200.GB4782@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Cyrill Gorcunov wrote:

>   Well, I've been using code reading. No real hardware test.
> I just don't have such a hardware.

 Then simulate it!  Proofreading is not enough -- the APIC code is too 
twisted.  Be imaginative -- for example you can clear the APIC bit at the 
time CPUID flags are saved for later use with cpu_has_apic() and see if 
the code behaves as expected.  Sprinkle printk()s here and there to see if 
variables are set correctly, whether the right code paths are taken, etc.  
Tedious?  Well, who said kernel debugging was going to be a piece of cake?

 Most of the APIC support code I have written has been run-time tested 
like this -- one change at a time.  Do you think I have an infinite number 
of SMP configurations too?  All the clean-ups I worked on last year were 
tested with one laptop.  I didn't even have a serial port for console 
dumps back then.

 NAK from me until you've tested it, sorry.

  Maciej
