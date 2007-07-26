Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXGZEQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXGZEQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXGZEQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:16:03 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59188
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXGZEQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:16:03 -0400
Date: Wed, 25 Jul 2007 21:14:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Len Brown <lenb@kernel.org>
cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707260007.59203.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0707252113020.21378@asgard.lang.hm>
References: <200707252340.46505.a1426z@gawab.com> <200707260007.59203.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Len Brown wrote:

> On Wednesday 25 July 2007 16:40, Al Boldi wrote:
>> Linus Torvalds wrote:
>>> On Wed, 25 Jul 2007, Len Brown wrote:
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
>>>> release
>>>>
>>>> Fixes regressions -- a build failure, an oops, some dmesg spam.
>>>> Also fixes some D-state issues and adds ACPI module auto-loading.
>>>> Yes, I'd hoped to get the last two in before rc1.
>>>> I'm hopeful that a couple-days into rc2 is sufficiently early for them.
>>>
>>> I hate pulling this, but I did. However, what I hate even more after
>>> having done so is that ACPI now seems to select CPU hotplug. Why?
>>>
>>> That is just *broken*. Sure, if you select STR or hibernation, we need CPU
>>> hotplug,
>>
>> You are kidding, right?  CPU hotplug is broken big time; it kills a machine
>> like virus-scanner.  I always turn it of as a rule.  And now you want
>> STR/STD to be dependent on it?  Even on UP?  Why?
>
> CPU_HOTPLUG is needed to take the non-boot processors off-line before the suspend,
> and to bring them on-line upon the resume.  If you have specific problems
> with bringing logical processors offline and online, then please speak up
> because many are depending on this functionality working.

nobody is arguing that CPU_HOTPLUG should not be a requirement for 
suspend, what we are questioning is why simply enabling ACPI should 
require CPU_HOTPLUG.

not everyone who configures ACPI wants to use suspend (of any flavor)

David Lang
