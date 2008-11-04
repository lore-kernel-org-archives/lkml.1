Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYKDGbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYKDGbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKDGbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:31:07 -0500
Received: from fwc.sitour.cz ([62.209.212.18]:1694 "EHLO kali.sitour.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYKDGbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:31:06 -0500
Message-ID: <490FEC1B.5070105@mydatex.cz>
Date: Tue, 04 Nov 2008 07:30:51 +0100
From: Daniel Smolik <marvin@mydatex.cz>
Organization: Mydatex s.r.o.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.8.0.14eol) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.13~pre080323b-0etch3)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [Bugme-new] [Bug 11886] New: without serial console system doesn't
 poweroff
References: <bug-11886-10286@http.bugzilla.kernel.org/> <20081103130505.d5b45f87.akpm@linux-foundation.org> <490F726F.6070204@mydatex.cz> <200811040148.34707.rjw@sisk.pl>
In-Reply-To: <200811040148.34707.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Monday, 3 of November 2008, Daniel Smolik wrote:
>> Andrew Morton napsal(a):
>>> (switched to email.  Please respond via emailed reply-to-all, not via the
>>> bugzilla web interface).
>>>
>>> On Wed, 29 Oct 2008 04:06:11 -0700 (PDT)
>>> bugme-daemon@bugzilla.kernel.org wrote:
>>>
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=11886
>>>>
>>>>            Summary: without serial console system doesn't  poweroff
>>>>            Product: Power Management
>>>>            Version: 2.5
>>>>      KernelVersion: 2.6.27.4
>>>>           Platform: All
>>>>         OS/Version: Linux
>>>>               Tree: Mainline
>>>>             Status: NEW
>>>>           Severity: normal
>>>>           Priority: P1
>>>>          Component: Other
>>>>         AssignedTo: power-management_other@kernel-bugs.osdl.org
>>>>         ReportedBy: marvin@mydatex.cz
>>>>
>>>>
>>>> Latest working kernel version:
>>>> Earliest failing kernel version:2.6.27.2
>>>> Distribution: Debian Etch
>>>> Hardware Environment: Supermiro C2SBC-Q  Dual Core Intel Cpu 1G RAM
>>>> Software Environment: Debian Etch
>>>> Problem Description: If I does't add serial console to kernel command line
>>>> system doesn't poweroff. Linux hangs there:
>>>>
>>>> e1000e 0000:0d:00.0: PCI INT A disabled
>>>> e1000e 0000:00:19.0: PCI INT A disabled
>>>> ACPI: Preparing to enter system sleep state S5
>>>> Disabling non-boot CPUs ...
>>>>
>>>> If I disable in kernel config Suspend to Ram and Hibernate all works without
>>>> console. But with Suspend and hibernate enabled and serial console  added to
>>>> kernel cmd line all works too:
>>>>
>>>> e1000e 0000:0d:00.0: PCI INT A disabled
>>>> e1000e 0000:00:19.0: PCI INT A disabled
>>>> ACPI: Preparing to enter system sleep state S5
>>>> Disabling non-boot CPUs ...
>>>> CPU 1 is now offline
>>>> SMP alternatives: switching to UP code
>>>> CPU1 is down
>>>> Power down.
>>>> acpi_power_off called
>>>>
>>>> Steps to reproduce:
>>>> Compile kernel with attached config and try poweroff without serial console.
>>>>
>>> OK, this is weird.
>>>
>>> But the good news is that there is a very small number of commits
>>> between 2.6.27.2 and 2.6.27.4.
>>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.3
>>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.4
>>>
>>> I'd be looking at these:
>>>
>>> commit 3b987ac961486373f91191b14291b331fa546072
>>> Author: Rafael J. Wysocki <rjw@sisk.pl>
>>> Date:   Sat Sep 6 13:13:01 2008 +0200
>>>
>>>     ACPI suspend: Always use the 32-bit waking vector
>>>     
>>>     commit a6629105dd03d370fcb31e97bddf223fa4bb651e upstream.
>>>
>>>
>>> commit 66036f5862883fcc9f7ff8550685a5a3de1a57e4
>>> Author: Rafael J. Wysocki <rjw@sisk.pl>
>>> Date:   Sat Oct 4 00:05:05 2008 +0200
>>>
>>>     ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
>>>     
>>>     commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768 upstream.
>>>
>>>
>>>
>>> presumably 2.6.28-rc3 is also broken?
>> I don't know I can test it on Thu. But may be may fault or misunderstanding fist kernel which I test is 2.27.2. I don't 
>> test any kernel before. I don't know if 2.6.26 works.
> 
> Can you try 2.6.26, please?
Yes, no problem.

		Dan




