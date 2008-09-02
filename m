Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbYIBOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbYIBOrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYIBOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:47:10 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:62922 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYIBOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:47:10 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=0293pyo6kgtKc931nBwA:9 a=DeaA8v4gCwvuDw17-IkA:7 a=TZR7hcO5K-PXECx-4pFa4wfqOdsA:4
Message-ID: <48BD51F0.9080701@shaw.ca>
Date: Tue, 02 Sep 2008 08:47:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Radu Rendec <radu.rendec@ines.ro>
CC: linux-kernel@vger.kernel.org
Subject: Re: IRQ routing / assignment issue
References: <fa.Ayf504otegg3VVbRsozI1UFd/6Y@ifi.uio.no> <48BC248E.702@shaw.ca> <1220350993.16764.27.camel@blade.ines.ro>
In-Reply-To: <1220350993.16764.27.camel@blade.ines.ro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radu Rendec wrote:
> On Mon, 2008-09-01 at 11:21 -0600, Robert Hancock wrote:
>> The kernel doesn't really have any way to change the physical 
>> device/slot to IRQ mapping. In some cases there are BIOS settings which 
>> might influence this, but in most cases it's impossible to change (i.e. 
>> devices physically wired to the same IRQ line).
> 
> Thanks for your quick reply. I know there are 4 physical interrupt
> lines, interleaved for the many devices connected to a bus, so that, if
> most of the devices issue INTA, the interrupts are actually asserted on
> different pins of the apic (an almost uniform distribution of the
> interrupts, but still, two devices can share the same physical line). I
> also know that it's possible to change the (logical) irq levels assigned
> to physical INTA-INTD (perhaps using the pirq= parameter).
> 
> As I have limited knowledge of hardware implementations, I'm asking you
> if it's usual/possible for a dual-processor system to have the same
> physical irq pin connected to the same irq line of _different_ pci
> buses. To put it in other words, is it possible for two devices on
> _separate_ pci buses to physically share the same irq pin?

Most of the systems I've seen with multiple PCI buses (servers, mostly) 
have normally had separate IRQ pins for each slot for at least INTA, in 
fact. However, I don't think there's any reason why you couldn't have 
the same IRQ pin routed to slots on different buses..
