Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZLVC7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZLVC7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 21:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZLVC7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 21:59:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:35494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZLVC7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 21:59:10 -0500
Message-ID: <4B3035B0.9030303@kernel.org>
Date: Mon, 21 Dec 2009 18:57:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain> <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com> <alpine.LFD.2.00.0912212107560.5520@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912212107560.5520@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
>>> Shaohua Li (3):
>>>      ACPI: Add a generic API for _OSC -v2
>>>      ACPI: cleanup pci_root _OSC code.
>>>      ACPI: Add platform-wide _OSC support.
>> it seems these three patches broke the _OSC on my intel new systems.
>>
>> revert them fix the problem with AER and pciehp and etc
> 
> Yinghai,
> does 3563ff964fdc36358cef0330936fdac28e65142a work or fail on your 
> system?  That is (ACPI: Add platform-wide _OSC support)
> on top of 2.6.32 with no other changes.
> 

only revert that does NOT make _OSC on my system work again.

Thanks

Yinghai
