Return-Path: <linux-kernel-owner+w=401wt.eu-S933485AbXGSNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbXGSNiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbXGSNiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:38:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:56544 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759680AbXGSNiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:38:03 -0400
Message-ID: <469F6941.9010901@qumranet.com>
Date: Thu, 19 Jul 2007 16:38:09 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dor Laor <dor.laor@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com> <20070718191433.GB24545@csclub.uwaterloo.ca> <469F2D8C.7020805@qumranet.com> <20070719131718.GC5623@csclub.uwaterloo.ca>
In-Reply-To: <20070719131718.GC5623@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Jul 19, 2007 at 12:23:24PM +0300, Avi Kivity wrote:
>   
>> No, it means disallowing pci devices that use shared irqs, and allowing 
>> pci devices that use non-shared irqs.
>>     
>
> Most machiens I see today have almost no chance of having PCI devices
> without shared IRQs.  This probably means any implementation will only
> work on a small set of machines with very specific setup in terms of
> which PCI slots they install cards in, and only as long as you don't
> allow any type of hotplugging of devices (or ever changing hardware at
> all).  May not be worth implementing if it has such a limited use case.
> The MSI setup on the other hand does sound like it might have potential
> for working in general.
>
>   

Looking at two random servers here and a desktop, interrupts are 
unshared except for usb.  A laptop was not so lucky.  So "no chance" is 
a bit extreme.

I agree it's far from optimal, but it is less limited than you imply.


-- 
error compiling committee.c: too many arguments to function

