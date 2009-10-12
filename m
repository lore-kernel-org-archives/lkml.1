Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZJLAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZJLAdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZJLAdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 20:33:07 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:62022 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZJLAdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 20:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rZmoAtktVJcXbjM5kJEKC6fE33gsVkgxJ0pH6Tm/+6nSaXs9pNa+Ucr/f9jI8NCytR
         FavkH95K0nomFT0Gz2yASxBHuY+CzXSqeaz0+9khpkzR50GqxKCQQozYRZYqyaFxXGic
         /YfYvxArSJ1LrMxAg4RCPwY9Wyp5bAFJj1xu8=
MIME-Version: 1.0
In-Reply-To: <20091011090549.GE1414@ucw.cz>
References: <20091006074533.GA28889@july> <20091011090549.GE1414@ucw.cz>
Date: Mon, 12 Oct 2009 09:32:28 +0900
X-Google-Sender-Auth: beb9cc1770cea539
Message-ID: <9c9fda240910111732x262a9510rf3dd862aa16d0bdf@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
From: Kyungmin Park <kmpark@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 6:05 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-10-06 16:45:33, Kyungmin Park wrote:
>> This patch includes two haptic devices, isa1000 and isa1200
>> ISA1000 is gpio based haptic, but isa1200 is based on I2C
>> Both are working on Samsung SoCs and tested.
>>
>> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
>> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
>> or
>> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot
>
> New device classes should certainly be documented in Documentation/.
>
> For example... is level 0-100?

Basically. range from 0 to 255. also each device can set max level in
case of isa1000 it's 6.

>  Is it valid to change level while 'oneshot' is running?

we usually use it under 1 sec. but I think it's possible to change it
but not tried.

>  Does oneshot use last level set?

Right. it used last set value.

If you don't mind to update these at Documentation please wait until
commit first patches merged.

Thank you,
Kyungmin Park
