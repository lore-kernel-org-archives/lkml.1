Return-Path: <linux-kernel-owner+w=401wt.eu-S1764995AbXGSJXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764995AbXGSJXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbXGSJXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:23:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:38114 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXGSJXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:23:16 -0400
Message-ID: <469F2D8C.7020805@qumranet.com>
Date: Thu, 19 Jul 2007 12:23:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dor Laor <dor.laor@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com> <20070718191433.GB24545@csclub.uwaterloo.ca>
In-Reply-To: <20070718191433.GB24545@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Wed, Jul 18, 2007 at 07:46:13PM +0300, Avi Kivity wrote:
>   
>> IMO the only reasonable solution is to disallow interrupt forwarding
>> with shared irqs.  If someone later comes up with a bright idea, we can
>> implement it.  Otherwise the problem will solve itself with hardware
>> moving to msi.
>>     
>
> Disallowing shared IRQs means disallowing PCI devices in general, so now
> you are back to ISA only devices, which it sounds like were the only
> things already allowed by vm86 or whatever it was for passing through.
>
>   

No, it means disallowing pci devices that use shared irqs, and allowing 
pci devices that use non-shared irqs.

> Certainly does appear to have potential though for allowing more
> interesting virtual machines.
>   

IMO pass-through is counter to most of the benefits of virtualization.  
But users seem to want it.

-- 
error compiling committee.c: too many arguments to function

