Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0BQFni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:43:38 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:52295 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0BQFng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hh/JftkGR8tqFXJtRCn6/faT/02uOXaznIeMqGKYcBfrWlUZlAJLUcqRlqz7JtkBGb
         kJRnXuYArs0IifUSwIFhLaTE/OYXk3n4IqnPmsRghkHez0H4XZc9n0nJzysAmv9KdgAR
         KC4278JZK2Yd/1jOGg6rIawPKQojPiXHP0/qI=
MIME-Version: 1.0
In-Reply-To: <20100217124312.e6d47c21.kamezawa.hiroyu@jp.fujitsu.com>
References: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
	 <20100217115313.30de11fb.kamezawa.hiroyu@jp.fujitsu.com>
	 <f22d86811002161916s292436b7hf564269a37dbe9af@mail.gmail.com>
	 <20100217124312.e6d47c21.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 17 Feb 2010 11:13:35 +0530
Message-ID: <f22d86811002162143p2296d67arebe0e62e2b4ac90f@mail.gmail.com>
Subject: Re: Notification when a task is created/exits
From: "Leonidas ." <leonidas137@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This sounds close to what I have in mind, but unfortunately I dont
>> have any idea what is cgroup
>> subsystem. How to implement cgroup subsystem? Can you give pointers to
>> some existing code
>> or document?
> Documentation/cgroup/*.txt
> Maybe cpuacct cgroup in kernel/sche.c or device cgroup in security/device_cgroup.c
> is portable size, but they are not module.
> block/blk-cgroup is module and maybe in readable size.

Will go through it.

>
>> Also, using this mechanism can we monitor each thread created in
>> user space? I.e. it is only a fork handler or even a
>> pthread_create/clone can be tracked this way.
>>
> please read documents. I think you can.
>

Okay, if it can then this is what I have been looking for...Thanks for
the pointers.

> Thanks,
> -Kame
>
>



-- 


-Leo.
