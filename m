Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZAFADp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZAFADp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAFAD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:03:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:49497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZAFADZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:03:25 -0500
Message-ID: <49629FAF.6060709@kernel.org>
Date: Mon, 05 Jan 2009 16:02:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: david@lang.hm
CC: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
References: <20090102174845.GD5372@localhost>  <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>  <20090103161052.GB11093@localhost>  <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>  <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>  <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>  <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>  <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com> <86802c440901051407ib7e69fey527dcce77cd2a461@mail.gmail.com> <alpine.DEB.1.10.0901051520210.27641@asgard.lang.hm> <alpine.DEB.1.10.0901051649250.28400@asgard.lang.hm> <alpine.DEB.1.10.0901051653290.28400@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0901051653290.28400@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 5 Jan 2009, david@lang.hm wrote:
> 
>> On Mon, 5 Jan 2009, david@lang.hm wrote:
>>
>>> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>>>
>>>> can you make sure X86_64_APCI_NUMA is set?
>>>>
>>>> # CONFIG_X86_64_ACPI_NUMA is not set
>>>
>>> will do, recompiling...
>>
>> new version up at http://linux.lang.hm/linux
>>
>>
>> the -6 builds are the latest ones, pictures are still arriving
>>
>> 38 earlyprintk=vga
>> 38 earlyprintk=vga numa=noacpi
>> 38 earlyprintk=vga numa=off
>> 38 earlyprintk=vga numa-noacpi bootmem_debug
>>
>> I forgot to try and move the memory hole, I'll reboot and try that.
> 

any 64bit kernel before 2.6.28 works on that system?

YH
