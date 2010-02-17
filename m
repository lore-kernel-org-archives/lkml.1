Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0BQWKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:10:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42245 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0BQWKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cacBvS7WesmDFei1/eJ/zJ/i6K+LwytM19Nh7qC4+q89e3zto6lWtXe21PpVQoOaNN
         Oa2sZKhr/5AQFOv5KxDI8+ry7LVwBQQP4HifTimz2BuMmpQOo0Twv0Prq6JKmExjeYNd
         4MwgN5t/D0cJNClg03+//qlHL0/guZsPKzwKc=
MIME-Version: 1.0
In-Reply-To: <201002172152.39255.rjw@sisk.pl>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
	 <201002172111.42511.rjw@sisk.pl> <201002172152.39255.rjw@sisk.pl>
Date: Wed, 17 Feb 2010 22:10:32 +0000
Message-ID: <74fd948d1002171410l5688c3dfy125ac5c7e80ad1a1@mail.gmail.com>
Subject: Re: 2.6.33-rc8 regression on i915: resume from hibernate locks up 
	every 2nd time
From: Pedro Ribeiro <pedrib@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/17 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday 17 February 2010, Rafael J. Wysocki wrote:
>> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
>> > Hi,
>> >
>> > commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
>> > while aborting hibernation) introduced two new issues which were not
>> > present in 2.6.33-rc7:
>> >
>> > - every second resume from hibernate results in a blank screen
>> > - the annoying flash at the end of atomic copy/restore during the
>> > hibernate process is back (present in kernels < 2.6.33)
>> >
>> > The first issue is serious, the second is just an annoyance.
>>
>> The second one is an expected price of fixing the aborted hibernation
>> regression.
>>
>> The first one shouldn't happen, though.
>>
>> I'll see if I can reproduce that locally.
>
> No, I can't.
>
> Is the driver compiled directly into the kernel or modular?
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

The driver is modular.
And sorry, I forgot to tell you I'm using TuxOnIce, it certainly makes
a difference.

However, every since I reverted that commit I've done 10 test
hibernations and no hang so far.

Pedro
