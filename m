Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXLDPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXLDPvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXLDPvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:51:37 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1217 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXLDPvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:51:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Dec 2007 15:51:33.0709 (UTC) FILETIME=[8B665FD0:01C8368D]
Content-class: urn:content-classes:message
Subject: Re: Is the PCI clock within the spec?
Date: Tue, 4 Dec 2007 10:51:33 -0500
Message-ID: <Pine.LNX.4.61.0712041033020.9021@chaos.analogic.com>
in-reply-to: <47556E48.40703@free.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Is the PCI clock within the spec?
thread-index: Acg2jYtwC4EK2xnAR9abK2VbLVJC9Q==
References: <475532A7.1000408@free.fr> <20071204134254.5db8e27d@bull.net> <475555A6.3060202@free.fr> <Pine.LNX.4.61.0712040839250.8751@chaos.analogic.com> <47556E48.40703@free.fr>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "John Sigler" <linux.kernel@free.fr>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Dec 2007, John Sigler wrote:

> Dick Johnson wrote:
>
>> You can't just touch a scope-probe to the PCI
>> clock pin and clip the scope-probe grounding
>> lead to a convenient "ground" to make these
>> measurements! You need a special fixture that
>> will make a low-inductance connection to the
>> PCI bus in the same manner as the interface chip.
>
> (This is waaay over my head.)
>
> Why do you think the two plots (at least the second one)
> were not obtained as you describe?
>

They didn't describe the test setup, simply supplied a
"go away and don't bother me" picture of something
that means nothing.

>
> Why would the system manufacturer botch the measurements
> when I asked them to show me evidence that their system
> was compliant?
>

I think they just sent you a picture, thinking it would
make you go away. It is a common ploy.

>> A scope probe will allow you to see if there is
>> a clock signal. That's all. You can't determine
>> its quality. A 4-inch ground lead on the scope
>> probe will result in 10-20% overshoot and undershoot
>> being observed.
>
> I don't understand this 10-20% figure.
> (0V + 10-20% is still 0V.)
>

There is a definition of overshoot and undershoot. 10 percent
undershoot will show a 0->3.3 volt signal going 0.33 volts
below "ground," i.e., -0.33 V on peaks. 10 percent overshoot
will show a 0->3.3 volt signal going to 3.63 volts above ground
on peaks, i.e., +3.63 volts.

> AFAIU, the nominal peak-to-peak voltage is 3.3V. The observed
> peak-to-peak voltage is 6.08V (3.3V + 84%).
>

This may be a "5 volt" bus. 3.3 volt devices are supposedly
5 volt tolerant. For instance, the PLX, PCI 9656BA, probably
the most common PCI interface chip in use, will handle those
voltages fine. The actual logic-level switch occurs at about
1.5 volts. Since the PCI bus is clocked, it is unlikely
that a "lockup" you describe is caused by the bus, more
likely a hung DMA operation caused by a failure to handle
errors (hardware or software, cause unknown). With the
chip I describe, it can be programmed so that it will not
hold the bus "forever," with a hung DMA operation. However,
some cooperation with the stuff in your FPGA as well as
the software in the driver is necessary.

> Regards.
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.27 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
