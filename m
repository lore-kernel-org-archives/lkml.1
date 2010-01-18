Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837Ab0ARSJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0ARSJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827Ab0ARSJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:09:33 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41227 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab0ARSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ot131hziSFj4G8z0MgUemZhSSdyXAsUI32e+jC8H0OTKc/0t1Vk2HzmbrNhP21zQ+c
         q0otBzGHJ/EAq0jIXjJQDrKGfdzd3xOfLd6ddmUiU8eYxwoFW6HzK695Z9HWzRZ8JCYV
         MZX121hDHYu0mJr4di4OupaNErhFncMp35cyo=
MIME-Version: 1.0
In-Reply-To: <20100118170816.GA22111@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	 <20100118141938.GI30698@redhat.com>
	 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	 <20100118170816.GA22111@redhat.com>
Date: Mon, 18 Jan 2010 20:09:26 +0200
X-Google-Sender-Auth: c496878641d82a20
Message-ID: <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Mon, Jan 18, 2010 at 7:08 PM, Gleb Natapov <gleb@redhat.com> wrote:
>> "Greater control" is not an argument for adding a new API that needs
>> to be maintained forever, a real world use case is.
>>
> If there is real world use case for mlockall() there is real use case for
> this too. People seems to be trying to convince me that I don't need
> mlockall() without proposing alternatives. The only alternative I see
> lock everything from userspace.
>
>> And yes, this stuff needs to be in the changelog. Whether you want to
>> spell it out or post an URL to some previous discussion is up to you.
> The discussion was here just a couple of days ago. Here is the link
> were I describe my use case: http://marc.info/?l=linux-mm&m=126345374125942&w=2
> If you think it needs to be spelled out in commit log I'll do it.

So this is a performance thing? Btw, is there are reason you can't use
plain mlock() for it as suggested by Peter earlier?

                        Pekka
