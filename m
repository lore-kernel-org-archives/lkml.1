Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYBKQar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYBKQar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYBKQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:30:39 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:26553 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755562AbYBKQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:30:37 -0500
X-Trace: 681778005/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGQGsEdRAVlC/2dsb2JhbACBWacj
Message-ID: <23228.85.118.17.158.1202747372.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20080211112433.ZZRA012@mailhub.coreip.homeip.net>
References: <1202684222.6237.9.camel@localhost.localdomain>
    <200802101922.29214.vapier@gentoo.org>
    <15561.85.118.17.158.1202739603.squirrel@newgolddream.dyndns.info>
    <200802111119.23841.vapier@gentoo.org>
    <20080211112433.ZZRA012@mailhub.coreip.homeip.net>
Date: Mon, 11 Feb 2008 16:29:32 -0000 (UTC)
Subject: Re: [PATCH 1/2] SH/Dreamcast - joystick (Control pad)
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Mike Frysinger" <vapier@gentoo.org>,
       "Paul Mundt" <lethal@users.sourceforge.net>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, February 11, 2008 4:25 pm, Dmitry Torokhov wrote:
> On Mon, Feb 11, 2008 at 11:19:22AM -0500, Mike Frysinger wrote:
>> On Monday 11 February 2008, Adrian McMenamin wrote:
>> > On Mon, February 11, 2008 12:22 am, Mike Frysinger wrote:
>> > > no remove function ?  looks like the probe() forces a connect, but
>> > > there's no remove() to force a disconnect ...
>> >
>> > Removing these devices (or any other plugged directly into the maple
>> > ports) is a quick way to destroy your Dreamcast: hence they were never
>> > implemented I guess. But there is no convincing reason for the
>> software
>> > not doing so, I suppose. I can just put in comments about it.
>>
>> and not allow the driver to be built as a module until the comments
>> become
>> code ...
>> -mike
>
> Normally drivers can be unbound from devices via sysfs even if they are
> built-in, not modules.
>
>
I meant comments about not being so silly as to start plugging maple
devices in and out of the ports on the DC. I understand the point about
the code and will rework appropriately.

All I wanted to do is take somebody's old code and get it to work on 2.6.
But nothing is that simple :-/

