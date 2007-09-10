Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbXIJTMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbXIJTMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbXIJTMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:12:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114AbXIJTM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:12:29 -0400
Message-ID: <46E59716.6020404@redhat.com>
Date: Mon, 10 Sep 2007 15:12:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <46E1A7B5.6000104@redhat.com> <200709080717.58271.prakash@punnoor.de>
In-Reply-To: <200709080717.58271.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2007 01:17 AM, Prakash Punnoor wrote:
> On the day of Friday 07 September 2007 Chuck Ebbert hast written:
>> On 09/06/2007 07:31 AM, Andi Kleen wrote:
>>> Chuck Ebbert <cebbert@redhat.com> writes:
>>>> Some systems lock up without the noapic option.
>>> Please find patterns: cpu type, chipsets, mainboard vendors etc.
>> This is the first one I've actually had in front of me:
>>
>>   HP TX1000 notebook
>>   Nvidia C51/MCP51 mobile chipset
> 
> Do you have a hpet? If not, have you tried using acpi_use_timer_override with 
> apic?

Yes, it has an hpet. And I tried every combination of options I could
think of.

But, even stranger, x86_64 works (only i386 fails.)
