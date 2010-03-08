Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0CHG3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:29:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CHG3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:29:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ErW+m6IemfNgOhPoUPz1gFtNnxZA/FQPau5gUXcGvBSQjA1snjrBzIVrnALlJEI0H
	eNyWdoeoXIBqbhAgHzP3A==
MIME-Version: 1.0
In-Reply-To: <20100307204933.GC17727@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <20100303190753.GB11471@core.coreip.homeip.net>
	 <4B8EB99F.4080104@jic23.retrosnub.co.uk>
	 <20100303230229.77df3ac3@hyperion.delvare>
	 <404ea8001003031508p32641b2bj8781ce2b88e1f9cb@mail.gmail.com>
	 <20100307204933.GC17727@core.coreip.homeip.net>
Date: Sun, 7 Mar 2010 22:29:35 -0800
Message-ID: <404ea8001003072229n47269b44r5d1fc17385c5bbc9@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Dima Zavin <dmitriyz@google.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 7, 2010 at 12:49 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Mar 03, 2010 at 03:08:29PM -0800, Dima Zavin wrote:
>>
>> As it came up earlier in the thread, adding an ABS_AMBIENT_LIGHT_LEVEL
>> or equivalent is much simpler and provides a clean, concise, and
>> useful interface to userspace.
>>
>> Note that for many applications, you actually get configurable
>> threshold levels, and the hardware triggers an interrupt when the
>> light level crosses those thresholds. This makes using an input device
>> very useful, and that is in fact how we use ALS devices today. I have
>> several pieces of hardware that do this, and I don't see how this new
>> als subsystem helps me handle that problem. With the suggested API,
>> I'll have to poll the sysfs files manually to see if they've changed
>> (which is suboptimal), or still add a non-standard input device to do
>> what I want.
>>
>
> OK, so from what you are saying it looks you just like the _interface_,
> or transport, that input subsystem provides, not the fact that you
> considering the device to be a HID-type device. If this is the case then
> this indicates that we need to take another look at the proposed
> interface and make sure that it allows proper poll() support.

Yes, you are right. Though, the filtering that the input subsystem
provides can also be useful.

--Dima
