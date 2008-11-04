Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbYKDDND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbYKDDND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYKDDMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:12:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51004 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYKDDMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:12:37 -0500
Message-ID: <490FBD4E.2040308@jp.fujitsu.com>
Date: Tue, 04 Nov 2008 12:11:10 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org> <490FB397.8050809@jp.fujitsu.com> <20081104023837.GA12165@srcf.ucam.org>
In-Reply-To: <20081104023837.GA12165@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 11:29:43AM +0900, Kenji Kaneshige wrote:
>> Matthew Garrett wrote:
>>> What do you mean by "not work properly"? The hardware we've tested with 
>>> fires events even without an OSHP method being present. That's the case 
>>> we're trying to deal with.
>>>
>> Because the explanation of PCI Express Native Hot Plug control bit in
>> _OSC return value in PCI firmware spec says
>>
>> "... If firmware allows the operating system control of this feature,
>> then in the context of the _OSC method, it must ensure that all hot
>> plug events are routed to device interrupts as described in the PCI
>> Express Base Specification. ..."
>>
>> My understanding is that it is not ensured that all hot plug events
>> are routed to device interrupts, if hotplug control is not granted.
> 
> My understanding is that in the worst case the hardware/firmware won't 
> give us any events - that's basically equivalent to not having the 
> driver loaded at all. On hardware that gives us the events anyway, we 
> get some extra functionality.
> 
> Thanks for the feedback!

Ok, I understood that my worries are already within the scope of the
assumption.

Thanks,
Kenji Kaneshige





