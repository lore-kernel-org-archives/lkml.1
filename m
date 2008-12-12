Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbYLLTBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbYLLTBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYLLTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:01:37 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:54172 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLLTBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:01:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qyFGCG2HFd9g4zMnDoqdlN1ZIat/pNeNtXiJUDKVvwzJQY/LLnoz6pbTKYv+joqrXg
         3kpAEggF3zejfa5XS9tZl9e+dICY/8jTxe5C1UsuxTgNR94oPu+NDfZwjK6cg+BCgBxD
         QiHVp3FYtWqgSfoNVk0wyd+P3ogGS8zMR7lo4=
Message-ID: <b637ec0b0812121101n3983959cye1d64c54767ac915@mail.gmail.com>
Date: Fri, 12 Dec 2008 20:01:34 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <20081212185820.GF11974@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
	 <492DAC81.4020803@s5r6.in-berlin.de> <200811270002.29537.rjw@sisk.pl>
	 <b637ec0b0811270717t360ce5f9j3d48e8a007010b0e@mail.gmail.com>
	 <b637ec0b0811271354l58fc6039m941ca37fb9173d5b@mail.gmail.com>
	 <20081212185820.GF11974@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel

On Fri, Dec 12, 2008 at 7:58 PM, Pavel Machek <pavel@suse.cz> wrote:
> On Thu 2008-11-27 22:54:14, Fabio Comolli wrote:
>> Hi
>>
>> On Thu, Nov 27, 2008 at 4:17 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> > Hi
>> >
>> > On Thu, Nov 27, 2008 at 12:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> Actually, yes, Fabio, you can try to revert all of the "ACPI: EC:" commits
>> >> applied after 2.6.27.4 and retest.
>> >
>> > Will do tonight. I see that there are some other "ACPI: EC:" commits
>> > in 2.6.27.6 and 2.6.27.7.
>> >
>> > I'l just compile the ec.c file from 2.6.27.4 in 2.6.27.7 and test if
>> > the three commits introduced in 2.6.27.5 wouldn't revert cleanly,
>> >
>> > By the way, my HD passed a "smartctl -t long" test without any problems.
>> >
>>
>> Reproduced with 2.6.27.7 with ec.c taken from 2.6.27.4 - after three
>> minutes of freeze the laptop came back to normal as nothing had
>> happened.
>
> Is it possible to turn on printk timing, or something?

It's already enabled.

> If it is
> desktop machine, is there chance to pull some data out of the machine
> during resume (serial console, debug leds?).

It's a laptop without any serial ports unfortunately.

>
> Could you use Linus' RTC debugging hack, then hard reset machine after
> 1.5minute to see where it spends most of the time?

I'm almost done with a third bisection session (0 commit to test). If
I don't get any useful results I will try it.

>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Regards,
Fabio
