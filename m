Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZEXVVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZEXVVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEXVUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:20:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZEXVUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:20:51 -0400
Message-ID: <4A19BA09.4050502@zytor.com>
Date: Sun, 24 May 2009 14:20:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Chris Howie <cdhowie@gmail.com>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Subject: Re: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
References: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com> <200905242236.22715.rjw@sisk.pl>
In-Reply-To: <200905242236.22715.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 18 May 2009, Chris Howie wrote:
>> Folks:
>>
>> I've been running 2.6.29.1 for some time and reported an issue to this
>> mailing list a while ago about the boot process.  I believe I have now
>> nailed down the one factor that determines whether I see this issue.
>>
>> The problem arises only when booting or halting my laptop when there
>> is no power plugged in, e.g. the system is running on battery.
>> Sometime after init begins starting services I must hold down a key on
>> the keyboard to convince it to continue booting, otherwise it just
>> hangs.  If the system is running on AC then it boots fine.  This same
>> problem repeats itself during the halt process if running on battery.
>>
>> This also happens when resuming a suspend-to-disk image, after loading
>> the data from the hard drive, but before control is returned to
>> userspace.  The keyboard has no effect on this hang, presumably
>> because the kernel is not listening to the keyboard at this point.
>> When this happens the only solution is to hold the power button and
>> boot normally instead.
>>
>> An issue like this is a serious usability problem for me.  I am
>> neither a kernel developer nor hacker, my coding skills applying
>> mostly to userspace applications.  If there is anything you need from
>> me to help diagnose this problem please let me know.
>>
>> I am not subscribed so please CC me on replies.
> 
> Let's try to make your report a bit more visible (some CCs added).
> 

I presume it boots with "acpi=off"?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

