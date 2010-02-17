Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab0BQDQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:16:53 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:36631 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920Ab0BQDQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JevLQ3iYacAYsL2zP6OxSxIm2XeNVqJqwWUtO+35iTaKoJhDvKZLit+arEwRT9A1BJ
         orITxn3QNyBuXguZqgqr0LzkVFz9OibIQt6Lbo9jMui3tH8L6WE9eY1mfT7pJ63qdOZ5
         Gt5GkE5skxzLC2G+KtEsyYgaYl4U3RolwN7U8=
MIME-Version: 1.0
In-Reply-To: <20100217115313.30de11fb.kamezawa.hiroyu@jp.fujitsu.com>
References: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
	 <20100217115313.30de11fb.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 17 Feb 2010 08:46:51 +0530
Message-ID: <f22d86811002161916s292436b7hf564269a37dbe9af@mail.gmail.com>
Subject: Re: Notification when a task is created/exits
From: "Leonidas ." <leonidas137@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

>
>  1. use NETLINK and catch task create/exit in userland.
>    But this means "catch" is asyncronous.
>
This does not sounds like a possible solution to me in my setup. Using netlink
and having an user space component to do this job might be an over kill in what
I am doing.

>  2. implement cgroup subsystem
>    AFAIK, in the latest kernel, cgroup subsystem can be implemented as module.
>    cgroup has fork/exit handler.
>    And you can implement some useful controls for tasks you watch via
>    cgroup's control interface.
>

This sounds close to what I have in mind, but unfortunately I dont
have any idea what is cgroup
subsystem. How to implement cgroup subsystem? Can you give pointers to
some existing code
or document? Also, using this mechanism can we monitor each thread created in
user space? I.e. it is only a fork handler or even a
pthread_create/clone can be tracked this way.


> Thanks,
> -Kame
>
>
>> -Leo.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>



-- 


-Leo.
