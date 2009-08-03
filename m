Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZHCKmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZHCKmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZHCKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:42:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62766 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZHCKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:42:05 -0400
MIME-Version: 1.0
In-Reply-To: <aec7e5c30907261957x2793e8b9m8183bba0c3c2539f@mail.gmail.com>
References: <20090701083737.41f28c7d.erik@kryo.se>
	 <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com>
	 <200907262145.46363.rjw@sisk.pl>
	 <200907262252.41429.elendil@planet.nl>
	 <aec7e5c30907261957x2793e8b9m8183bba0c3c2539f@mail.gmail.com>
Date: Mon, 3 Aug 2009 12:42:05 +0200
X-Google-Sender-Auth: 3cd11f6ffff29f16
Message-ID: <f50a3dc50908030342v7d949638h750fc0fb5165fcf1@mail.gmail.com>
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
From: Erik Ekman <erik@kryo.se>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 04:57, Magnus Damm<magnus.damm@gmail.com> wrote:
> On Mon, Jul 27, 2009 at 5:52 AM, Frans Pop<elendil@planet.nl> wrote:
>> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
>>> In fact, I wouldn't advise anyone to do these conversions mechanically.
>>
>> With hindsight I'd say you are correct.
>>
>> In that case would it maybe have been better to have a build time warning
>> about the need to convert drivers rather than a run time one? Run time
>> warnings have a much higher annoyance factor and will thus "invite" more
>> people into having a shot at getting rid of them.
>
> I'm the one who added the runtime warning and I agree that a build
> time warning would have been more suitable. Exacly how to implement
> that in this specific case is another question. I'm open to
> suggestions. =)
>
> The purpose was simply to move over to the new interface sooner than later.
>
>> But I guess partly it's also just the nature of this change: it looks
>> trivial due to the corresponding terms.

Yes, that is why I gave it a try. I am trying to learn and looking for
stuff to fix this looked like a simple task. I dont have hibernation
configured and I am not sure if I have a serial port either so I will
leave this to the professionals.

>
> It should be pretty trivial. The tricky part is what gets used when in
> the cases of CONFIG_HIBERNATION and CONFIG_SUSPEND. The dev_pm_ops
> comment in include/linux/pm.h should guide people in the right
> direction.
>
> Thanks for your help!
>
> / magnus
>

/Erik
