Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582Ab0AYIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0AYIk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125Ab0AYIk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:40:56 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:55119 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0AYIk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:40:56 -0500
Message-ID: <4B5D5903.4000209@pardus.org.tr>
Date: Mon, 25 Jan 2010 10:40:35 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk, Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
References: <20100123001145.GA7391@kroah.com> <20100123232152.4b88d1e3.akpm@linux-foundation.org> <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote On 24-01-2010 18:29:
> On Sat, 23 Jan 2010, Andrew Morton wrote:
> 
>> On Fri, 22 Jan 2010 16:11:45 -0800 Greg KH <gregkh@suse.de> wrote:
>>
>>> This is the start of the stable review cycle for the 2.6.32.6 release.
>>> There are 29 patches in this series, all will be posted as a response to
>>> this one.  If anyone has any issues with these being applied, please let
>>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>>> to add a Signed-off-by: line to the patch, please respond with it.
>>>
>>> Responses should be made by Monday, January 24, 00:00:00 UTC.
>>> Anything received after that time might be too late.
>> 2.6.32.6 will still contain the regression described in (for example)
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=15117 
>> http://bugzilla.kernel.org/show_bug.cgi?id=15005
>>
>> It's fixed with the below revert which has been in -mm (and only in
>> -mm) for ten days.
>>
>> I don't what's going on - perhaps we're waiting for Thomas, and he's
>> otherwise engaged.  There's a fix in the lkml thread "Re: [RFC PATCH
>> 0/4] clockevents: fix clockevent_devices list corruption after cpu
>> hotplug" to which Thomas replied
>>
>>     I just applied your patch, but kept the cpuweight check.  This
>>     is the least intrusive solution for now.  The logic needs an
>>     overhaul, but thats neither rc4 nor stable material"
> 
> Just sent the pull request for it. Sorry for the delay. The patch
> needs to go into 32.6 as well.

tick-internal.h should be included for this to fix build failure. Already included
in 2.6.33 with 8e1a928a2ed7e8.

Regards,
