Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbZAFAUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbZAFAUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZAFATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:19:55 -0500
Received: from mail.lang.hm ([64.81.33.126]:48709 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZAFATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:19:55 -0500
Date: Mon, 5 Jan 2009 17:22:06 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <49629FAF.6060709@kernel.org>
Message-ID: <alpine.DEB.1.10.0901051717440.28514@asgard.lang.hm>
References: <20090102174845.GD5372@localhost>  <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>  <20090103161052.GB11093@localhost>  <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>  <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>
  <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>  <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>  <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com> <86802c440901051407ib7e69fey527dcce77cd2a461@mail.gmail.com>
 <alpine.DEB.1.10.0901051520210.27641@asgard.lang.hm> <alpine.DEB.1.10.0901051649250.28400@asgard.lang.hm> <alpine.DEB.1.10.0901051653290.28400@asgard.lang.hm> <49629FAF.6060709@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Yinghai Lu wrote:

> david@lang.hm wrote:
>> On Mon, 5 Jan 2009, david@lang.hm wrote:
>>
>>> On Mon, 5 Jan 2009, david@lang.hm wrote:
>>>
>>>> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>>>>
>>>>> can you make sure X86_64_APCI_NUMA is set?
>>>>>
>>>>> # CONFIG_X86_64_ACPI_NUMA is not set
>>>>
>>>> will do, recompiling...
>>>
>>> new version up at http://linux.lang.hm/linux
>>>
>>>
>>> the -6 builds are the latest ones, pictures are still arriving
>>>
>>> 38 earlyprintk=vga
>>> 38 earlyprintk=vga numa=noacpi
>>> 38 earlyprintk=vga numa=off
>>> 38 earlyprintk=vga numa-noacpi bootmem_debug
>>>
>>> I forgot to try and move the memory hole, I'll reboot and try that.
>>
>
> any 64bit kernel before 2.6.28 works on that system?

I'm pretty sure that I've done it on other systems from this buy, but on 
this system, no I don't have any working 64 bit system. I tried ubuntu 
8.10 and 8.04 before trying to use the config for my working 32 bit system 
as the basis for a make oldconfig to try and get a working 64 bit kernel 
to start using.

this motherboard is a Tyan Thunder K8S Pro S2882

I just uploaded some snapshots of the bios screens

David Lang
