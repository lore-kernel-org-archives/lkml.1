Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZG0C5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZG0C5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZG0C5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:57:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:45767 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZG0C5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KYZM0kHuD3iKPvcaRg3D9C1Yy+6j5T9DO2qjdXZr3oqWnvLNuJBZIQb3SX4f9O4edv
         kYmszzVIupLzxNrxPpycwPA+sLFlwkpsXTPOD0CrYtEnln/FmVBSHxARGyEg6ip4dnm/
         0e9u4bX705CAigyTYAdoQ7dyL5oH3fx+yT2k4=
MIME-Version: 1.0
In-Reply-To: <200907262252.41429.elendil@planet.nl>
References: <20090701083737.41f28c7d.erik@kryo.se>
	 <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com>
	 <200907262145.46363.rjw@sisk.pl>
	 <200907262252.41429.elendil@planet.nl>
Date: Mon, 27 Jul 2009 11:57:10 +0900
Message-ID: <aec7e5c30907261957x2793e8b9m8183bba0c3c2539f@mail.gmail.com>
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
From: Magnus Damm <magnus.damm@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Erik Ekman <erik@kryo.se>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 5:52 AM, Frans Pop<elendil@planet.nl> wrote:
> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
>> In fact, I wouldn't advise anyone to do these conversions mechanically.
>
> With hindsight I'd say you are correct.
>
> In that case would it maybe have been better to have a build time warning
> about the need to convert drivers rather than a run time one? Run time
> warnings have a much higher annoyance factor and will thus "invite" more
> people into having a shot at getting rid of them.

I'm the one who added the runtime warning and I agree that a build
time warning would have been more suitable. Exacly how to implement
that in this specific case is another question. I'm open to
suggestions. =)

The purpose was simply to move over to the new interface sooner than later.

> But I guess partly it's also just the nature of this change: it looks
> trivial due to the corresponding terms.

It should be pretty trivial. The tricky part is what gets used when in
the cases of CONFIG_HIBERNATION and CONFIG_SUSPEND. The dev_pm_ops
comment in include/linux/pm.h should guide people in the right
direction.

Thanks for your help!

/ magnus
