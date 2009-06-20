Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZFTB0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZFTB0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZFTB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:26:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:17972 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbZFTB0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cLyrbZdPK+AxsQzoGf3RRyUHYVfgzMQibe6sEOvWvASeFGzJnZnezLczHJtySeLe5o
         A3+Y5KsR1s08O8mOOut5Y1rLxj5l042DeQqwEMAP6HV1av8hXH4ybk0rupuEICXmGcGr
         i7MBKJXlejqtVKh8360Rdq3MILDyHJgUiEZ+w=
MIME-Version: 1.0
In-Reply-To: <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <1245249469.5982.251.camel@desktop> <4A390B9A.40806@goop.org>
	 <1245254936.5982.261.camel@desktop> <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
Date: Sat, 20 Jun 2009 10:26:47 +0900
Message-ID: <49b7c2350906191826j646133b3y4df000ad49501407@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: GeunSik Lim <leemgs1@gmail.com>
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/20 Arve Hjønnevåg <arve@android.com>:
>>
>> Did Google evaluate DBus at all?
>
> Some of our user-space code have in the past used or still use dbus,
> but as far as I know it has not been seriously considered as a
> replacement for the binder.
>
>> Also are there any userspace test cases
>> that Google used to test the performance of this interface. Or test
>> cases to compare the binder with something like sockets, or any other
>> type of IPC?
>>
>> If Google believes the binder is the right solution for IPC, how was
>> that conclusion formed?
>>
>> Daniel
>
> These are mostly questions for the framework team. The binder driver
> is there to support our user space code. At some point we used the
> driver from www.open-binder.org, but we ran into, and fixed, a lot of
> bugs (especially when processes died), so we determined it would be
> faster to rewrite the driver from scratch.
Ok, The binder driver is there to support our user space code as you explained.
Currently, Android platform selected both binder and Dbus for IPC mecanism as
http://blogfiles13.naver.net/data44/2009/6/20/108/binder-dbus-android-invain.png
and
android bluetooth architecture
diagram(http://sites.google.com/a/android.com/opensource/projects/bluetooth-faq).

Why did Google select  the two mechanism(both Binder and Dbus) for IPC
in androd software stack?
And, What is differenece about major roles  between Binder and Dbus in
Android OpenSource Project(AOSOP)?

* Binder as IPC
- http://www.open-binder.org
-Don't worry about processes or IPC  Because of distributed architecture.
-Provides resource management between processes.
-Handle on an object in another proces. ( lightweight sharing between
processes ???)
-Powerful facilities for doing multithreaded programming with the Binder.

* Dbus as IPC
- http://www.freedesktop.org/software/dbus/
- System for sending messages between applications. (Systemwide
message-bus service) -
- For example , Broadcast signal  and System/Session Bus for tasks in
Application Framework.


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
