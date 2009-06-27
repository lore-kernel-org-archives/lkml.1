Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZF0CUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZF0CUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 22:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZF0CUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 22:20:14 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62795 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZF0CUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 22:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FwH7tkRBld+jtYlLNWuecCA6OBjCtP3ySie2/M1J7WbtA+3vJwAjrN6Yhue7pA0vXP
         CPUCrkLziAPOc8o2YsCgpeyEQN0rjJQMgaW3hpCY97VkFd1WdhstuKt9o9Ze8rYoeVkV
         sNNdgcHoR/6u9eIfL28qaxuQkw/5W2Mplg5hI=
MIME-Version: 1.0
In-Reply-To: <1245936299.32124.299.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245458940.32124.45.camel@desktop>
	 <26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
	 <1245936299.32124.299.camel@desktop>
Date: Sat, 27 Jun 2009 11:20:14 +0900
Message-ID: <49b7c2350906261920j53243e14mff8721d4c0160dee@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: GeunSik Lim <leemgs1@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Dianne Hackborn <hackbod@android.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2009/6/19 Daniel Walker <dwalker@fifo99.com>
>> Most of these questions related to the fact that I don't think an
>> interface like this just slips into the kernel as a driver. Since it's
>> IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
>> we need to have some better and more specific information about it (or
>> atleast I do).
>
> Hi, sorry I have been slow to respond.  I can give a summary of how
> binder is used in the Android platform and the associated feature set.
>  I won't try to address other options, especially D-Bus, because
> honestly I haven't been following it for the last 3 or so years so
> don't really know its current state of art.
> Dianne Hackborn
Um. You means that  Android team selected Openbinder of beOS from Palm
for IPC mechanism in Android software stack 3 years ago.

At that time,
Framework team used Binder(= modified Openbinder core only) just
because D-bus is a premature for android opensource project like belows.
 -   dbus-0.1.tar.gz	(12-Jan-2005  17:20 ,	 309K)

After all,
Current android software stack consists of two IPC equipments like
Binder and D-bus without especial goal ( ? ) .


> I think the biggest issue I have with the binder implementation is that
> it's doing far too much in the kernel, it's not just IPC. It's also
> thread management, memory management, and lots of other stuff that I
> haven't figured out yet .. A lot of it can already be done in userspace.
> Daniel
I agree with your opinions.
I want  android framework team to improve IPC from two(Binder and D-ubs)
to one in the future.

D-bus is stable and mature for IPC currently as we all know.
This is used in the linux based distributions like Fedora, Ubuntu,
Suse successfully. D-bus also is connecting Udev(Userspace Device)
and sysfs(system filesystem)
well in embedded linux products as Nokie released commericial N8XX products.
I think that In theory as well as in practice, the idea of two IPCs was unsound.

Thks,



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
