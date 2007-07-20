Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbXGTNCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbXGTNCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbXGTNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:01:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:43639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbXGTNB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fb+C+0pGbYpx8KQGngmwtY1YphXcmujwKVCU6OVOZIZ+AojbdJR3huZrMTkJdmDRhTj6w0CZcJSmT5GWH57+qCi3GOXZbBoatDuKxFHeszBw4CicZFGY0nZyNFcncIF3mio+uSQLyMUhYv9o3uDeoeYUJorkepLycL+Is26+7aY=
Message-ID: <46A0B1DC.5030900@googlemail.com>
Date: Fri, 20 Jul 2007 15:00:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mm/Kconfig MEMORY_HOTPLUG typo ?
References: <46A0A954.4020102@googlemail.com> <20070720123649.GA27743@linux-sh.org>
In-Reply-To: <20070720123649.GA27743@linux-sh.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Fri, Jul 20, 2007 at 02:23:48PM +0200, Gabriel C wrote:
>> I'm a bit confused about the following from mm/Kconfig:
>>
>> ..
>>
>> config MEMORY_HOTPLUG
>>         bool "Allow for memory hot-add"
>>         depends on SPARSEMEM || X86_64_ACPI_NUMA
>>         depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
>>         depends on (IA64 || X86 || PPC64 || SUPERH)
>>
> MEMORY_HOTPLUG is only supported if !SOFTWARE_SUSPEND
> 
>> comment "Memory hotplug is currently incompatible with Software Suspend"
>>         depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND
>>
>>
>> ...
>>
>> That should be !SOFTWARE_SUSPEND no ?
>>
> However, we only give the comment that warns about the incompatability
> when SOFTWARE_SUSPEND is enabled, otherwise people won't see the option
> due to the unmet dependency.
> 

I think I got it :)

Thx for the clarification.


Gabriel
