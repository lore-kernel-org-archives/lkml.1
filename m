Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZHaM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZHaM3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZHaM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:29:45 -0400
Received: from rtr.ca ([76.10.145.34]:39530 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZHaM3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:29:45 -0400
Message-ID: <4A9BC239.9060009@rtr.ca>
Date: Mon, 31 Aug 2009 08:29:45 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com> <4A96819D.7060708@rtr.ca> <20090830225542.GB901@srcf.ucam.org>
In-Reply-To: <20090830225542.GB901@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Thu, Aug 27, 2009 at 08:52:45AM -0400, Mark Lord wrote:
> 
>> Just create a file called /etc/modprobe.d/pciehp,
>> and stick this one line into it:
>>
>>   options pciehp pciehp_force=1
>>
>> See if that works.
> 
> It's worth noting that Windows didn't support native pcie hotplug until 
> Vista, and so any hardware that works with XP (ie, basically all of it, 
> including Dells) is supposed to be using acpi hotplug instead. I've 
> fixed one bug that led to acpiphp not working on some hardware, but if 
> anyone's still running with pciehp_force=1 then please send me the 
> output of acpidump so it can be fixed properly.
..

My Dell works fine with PCIe hotplug under XP,
but not under Linux without pciehp=1.

I have not retested without that parameter for quite some time, though.
What do I have to do to retest with "acpihp" ?

Thanks.

