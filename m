Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYJOB5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYJOB5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJOB4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:56:54 -0400
Received: from meaning.com ([72.52.86.57]:55930 "HELO meaning.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751105AbYJOB4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:56:53 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 21:56:53 EDT
Message-ID: <48F54BB1.7040706@meaning.com>
Date: Tue, 14 Oct 2008 21:47:29 -0400
From: Glenn Powers <glenn@meaning.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Perfectly Random
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a proposal for a linux kernel module. This module will transfer 
entropy to /dev/random from nuclear decay random number generators. 
Addition information on this method of entropy generation can be found at:
http://www.fourmilab.ch/hotbits/

The lack of sufficient entropy is the Achilles Heel of cryptography and 
anyone who considers arithmetical methods of random sequence generation 
is, of course, in a state of sin. (D. Knuth, The Art of Computer 
Programming: Volume 2, Seminumerical Algorithms, 2nd edition, 
Addison-Wesley, 1981.) While I am quite familiar with sin, I often 
strive for something better.

Although any reasonable time base can be used for entropy generation, 
the best "something better" I've found is a not-so-hot three way between 
rubidium, cesium and quartz. The ultra-high quality quartz oscillator, 
rubidium gas and associated control electronics, called "L-PRO" or LPRO 
atomic frequency standard (manufactured by Efratom, Datum and now 
Symmetricom) can be purchased on eBay for US$100-US$200. The cesium is 
for long-baseline intervals, such that including a Pioneer-like star 
charts on your storage media would probably be a good idea. Combined, 
this is my definition of "non-random."

This precise time interval can be transferred to the linux kernel by 
constructing a TTL interface as described in the LPRO manual, connecting 
it to an available interrupt and changing the timer interrupt in the 
kernel. Rinse. Repeat.

Among the interesting properties of nuclear radiation is that it is both 
truly random and truly linear, depending how you look at it. Averaged 
over time, the nuclear decay rate is perfectly linear. This property has 
been used for decades for carbon-dating.

However, the exact instant of a nuclear event is dependent on the entire 
universe. This is makes it possible to extract entropy from four such 
events. It's a horse race between the time interval between the first 
and second events and the time interval between the third and four 
events. This method effectively decouples the decay rate from the 
entropy stream.

These nuclear events can be sensed with an opto-isolated Gieger/Mullen 
and are combined with the 10 MHz TTL LPRO signal using a NAND gate, 
which is then connected to an available system interrupt.

THE KERNEL MODULE WILL:

Copy the current CPU clock tick of these interrupts to a ring buffer.

THEN:

A Linux-RTAI application will compute the entropy and transfer it to 
/dev/random, a database or a network interface.

THEN:

The system can be tuned.

THEN:

The best tunings can be incorporated into the "RandomNuclear" module.

cheers,
glenn

