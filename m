Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZK2Jix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZK2Jix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZK2Jiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:38:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZK2Jiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:38:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=HqB20iNEKu0VP0y4RYa3aNDRlJm+3eTuwkEvVvXkYdQTTWmct5tZ+cBGYSqFouMX0
	UwYgkaCoMfwfzmnaD+JLg==
MIME-Version: 1.0
In-Reply-To: <20091129084351.GD1530@ucw.cz>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
	 <a55d774e0911280219s69729b54l544660aac4b2197@mail.gmail.com>
	 <20091129084351.GD1530@ucw.cz>
Date: Sun, 29 Nov 2009 01:38:50 -0800
Message-ID: <a55d774e0911290138j3d44a25aqce041f7a7a87d5a@mail.gmail.com>
Subject: Re: [PATCH 0/2] staging/android fixes
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Corentin Chary <corentincj@iksaif.net>,
       "Arve Hj??nnev??g" <arve@google.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 12:43 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > Here is a patch to fix build for android specifics drivers.
>> >
>> > What we should do next to prevent them from being removed in 2.6.23 ?
>> >
>> > Is there any chance that all android stuff would be merged one day ?
>> > Actually, we got a working 2.6.32 kernel for android here (with wakelock, ashm, etc..):
>> > http://git.iksaif.net/?p=android-x86/kernel;a=shortlog;h=refs/heads/android-x86-backport
>>
>> Arve's done a few revisions of the wakelock code with the linux-pm
>> list, and I know he's planning on trying to work through the remaining
>> issues (as I recall there was some discussion on read/write vs ioctl
>> interfaces to userspace) in the near future.
>>
>> This really is the one piece that has the most impact on everything
>> else -- maintaining versions of the various platform hardware drivers
>> with and without wakelock support is messy.
>
> It is really not that bad. Yes, it touches most drivers, but it is few
> lines per driver and easy to remove.
>
> Waiting for wakelocks (1year plus, AFAICT) before merging hw drivers
> seems like very slow way forward.

I'm not suggesting we hold off on everything until they're in, just
saying it'll simplify things once they are.

I'd like to get to a point where we can ship out of the upstream
kernel and that's going to need power management to work.  If we can
sort out wakelocks (as it seemed like we were getting close to),
that's one less difference to maintain.

Brian
