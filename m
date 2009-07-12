Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbZGLGe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbZGLGe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 02:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZGLGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 02:34:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46531 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZGLGet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 02:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EQ+sIJfOv7b/dH73kBIoFjQZMNUpaMZq/MHE8sCZezfhef+mjTZbTZUT+j5Pc5JwC1
         SKTX4MTNopSDsvpSJMiLe/rUI9g2Us/RTvmEUM2KLk5uC2HUSEQL2KvWtuXxFS76htA3
         jN39kljbouw45/2Z+p85cJDmLrFbUJbfuJcBs=
Date: Sun, 12 Jul 2009 10:34:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic - set cpu_has_apic for discrete apic
Message-ID: <20090712063445.GC4782@lenovo>
References: <20090711212929.GG5325@lenovo> <alpine.LFD.2.00.0907120141020.13862@eddie.linux-mips.org> <20090712055200.GB4782@lenovo> <alpine.LFD.2.00.0907120709220.13862@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907120709220.13862@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 12, 2009 at 07:31:44AM +0100]
| On Sun, 12 Jul 2009, Cyrill Gorcunov wrote:
| 
| >   Well, I've been using code reading. No real hardware test.
| > I just don't have such a hardware.
| 
|  Then simulate it!  Proofreading is not enough -- the APIC code is too 
| twisted.  Be imaginative -- for example you can clear the APIC bit at the 
| time CPUID flags are saved for later use with cpu_has_apic() and see if 
| the code behaves as expected.  Sprinkle printk()s here and there to see if 
| variables are set correctly, whether the right code paths are taken, etc.  
| Tedious?  Well, who said kernel debugging was going to be a piece of cake?
| 
|  Most of the APIC support code I have written has been run-time tested 
| like this -- one change at a time.  Do you think I have an infinite number 
| of SMP configurations too?  All the clean-ups I worked on last year were 
| tested with one laptop.  I didn't even have a serial port for console 
| dumps back then.
| 
|  NAK from me until you've tested it, sorry.

Started to... hope to publish results today!
Thanks Maciej!

| 
|   Maciej
| 
	-- Cyrill
