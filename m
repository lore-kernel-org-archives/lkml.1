Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbXGZFCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbXGZFCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbXGZFBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:01:52 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50472
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbXGZFBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:01:50 -0400
Date: Wed, 25 Jul 2007 22:00:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Len Brown <lenb@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707260026.08183.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0707252159160.21378@asgard.lang.hm>
References: <200707251238.50218.lenb@kernel.org> <200707251851.22777.lenb@kernel.org>
 <Pine.LNX.4.64.0707251917320.21378@asgard.lang.hm> <200707260026.08183.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Len Brown wrote:

>>> CONFIG_ACPI_SLEEP.  Not trivial for a user to select it
>>> when it doesn't even appear on the menu.  It doesn't appear
>>> because CONFIG_SUSPEND_SMP isn't enabled, but that doesn't
>>> appear either -- because CONFIG_HOTPLUG_CPU isn't selected.
>>
>> so have something like
>>
>> config ACPI_SLEEP
>>          select HOTPLUG_CPU if X86 && SMP
>>          select SUSPEND_SMP if X86 && SMP
>>
>> instead of makeing it dependant on ACPI.
>
> If more config options where better, then this
> would indeed be an improvement over 2.6.22.
> But more config options isn't better -- except for "some people":-)

coupling unrelated fetures togeather isn't better either.

David Lang
