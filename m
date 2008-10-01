Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYJAKRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYJAKRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYJAKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:17:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:16320 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYJAKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:17:41 -0400
Message-ID: <ac3eb2510810010317y774a8a80v4f1817187d8fc3a6@mail.gmail.com>
Date: Wed, 1 Oct 2008 12:17:39 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tom Spink" <tspink@gmail.com>
Subject: Re: CD tray closes spontaneously after opening it
Cc: "Frans Pop" <elendil@planet.nl>, "Tony Vroon" <tony@vroon.org>,
       linux-kernel@vger.kernel.org, "Tejun Heo" <tj@kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <7b9198260810010048q170c72f4wfc306505f1a6ac00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809301247.05367.elendil@planet.nl>
	 <200809301447.35915.elendil@planet.nl>
	 <ac3eb2510809300655u319f8a9v58e4825f97ee329c@mail.gmail.com>
	 <200809302150.38872.elendil@planet.nl>
	 <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com>
	 <7b9198260810010048q170c72f4wfc306505f1a6ac00@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 9:48 AM, Tom Spink <tspink@gmail.com> wrote:
> 2008/9/30 Kay Sievers <kay.sievers@vrfy.org>:
>> On Tue, Sep 30, 2008 at 9:50 PM, Frans Pop <elendil@planet.nl> wrote:
>>> On Tuesday 30 September 2008, Kay Sievers wrote:
>>>> Does:
>>>>   /sbin/udevadm monitor --env
>>>> print something while you see the tray closing?
>>>
>>> I was somewhat lucky to reproduce it with that running and there was no
>>> output during the open or close. I guess that rules out udev?
>>
>> I think so, yes.
>>
>>> I still don't know how to reliably reproduce this. It seems that after it
>>> has occurred once, it will not occur again unless the system is rebooted.
>>> But I'm not 100% sure of that.
>>>
>>> Most times I've seen it was after playing a DVD when ejecting the disc to
>>> put it back in its box, but not when the DVD was inserted earlier.
>>> But I've also seen it shortly after the system is booted when just opening
>>> the tray with no media inserted.
>>>
>>> Just to be clear: until recently the drive has always behaved perfectly in
>>> the same situations.
>>>
>>>> Does this also happen when you set:
>>>>   /proc/sys/dev/cdrom/autoclose
>>>> to 0?
>>>
>>> I'll set that on boot using /etc/sysctl.conf and will report if I can
>>> still reproduce with that setting. I've checked that the "normal" value
>>> is 1.
>>
>> That will prevent the closing, when something tries to open the device
>> in blocking mode. If that solves the issue, you should start looking
>> which process tries to access your drive.
>>
>> Kay
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Hi Kay,
>
> If you can manage to reproduce this, can you try/have you tried
> different kernel versions?

I didn't try. I have only slot-in optical drives and manual laptop
trays, there is no autoclose possible. I also have no box with IDE
drivers anymore, sorry.

Kay
