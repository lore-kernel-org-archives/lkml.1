Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZGaQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZGaQaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZGaQaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:30:20 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:55810 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZGaQaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <20090731160544.GA3430@kroah.com>
References: <Pine.LNX.4.44L0.0907301522570.6087-100000@iolanthe.rowland.org> 
	<ac3eb2510907301357j43189388lae6ec5d4e6ad365e@mail.gmail.com> 
	<20090731160544.GA3430@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 31 Jul 2009 12:30:03 -0400
Message-ID: <ac3eb2510907310930h2e5978een68341c15024aec30@mail.gmail.com>
Subject: Re: [PATCH] Driver core: add new device to bus's list before probing
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 12:05, Greg KH<greg@kroah.com> wrote:
> On Thu, Jul 30, 2009 at 04:57:06PM -0400, Kay Sievers wrote:
>> On Thu, Jul 30, 2009 at 15:27, Alan Stern<stern@rowland.harvard.edu> wrote:

>> > Kay, do you want this merged into 2.6.31 or are you okay with waiting
>> > for 2.6.32-rc1?  It changes a major core routine.  On the other hand,
>> > the problem it fixes does affect real users.
>>
>> I think it should go into -next and we wait a few days. It seems like
>> the proper fix, but we should make sure, we didn't miss something.
>>
>> After that, it would be nice if we can get that into 2.6.31, as we
>> have several problems already, which are likely solved by this.
>
> But as this isn't a regression (it's how things always have worked,
> right?),

Yeah, that sounds right, but I guess we have just been the needed bit
slower in the past, and with the recent speedups I would expect more
cases to uncover this issue.

> I'm a bit leary of pushing it to .31 right now, so late in the
> release cycle.  How about it goes to Linus for .32, and we backport it
> to -stable if it looks ok?

Sure, sounds fine too.

Would be good though to have it in -next soon. Three major distros are
preparing a new distro release at the moment, and they will likely
need to add that to their kernel to make this issue, USB firmware
loading, and similar things working again.

Thanks,
Kay
