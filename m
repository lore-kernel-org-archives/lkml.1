Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZFYABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZFYABT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZFYABG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:01:06 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZFYABF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PZubtTQ/d8isGTUfE15j8/Q0tGZpnawGcmrC7uWvwOrdDFv0dNfdxhJU0vcRnkOM7S
         iUuy9wc19/01bFv6FOoHeac4EHBYqIsx5Zo1ZqBWn5MbM8mx6Kzc3XZbA98PHRp0rFWY
         TjWxyzLT4NQjKfGEmGoZUW/+rFbe6IMxHRJ2Y=
MIME-Version: 1.0
In-Reply-To: <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <1245254936.5982.261.camel@desktop> <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
Date: Thu, 25 Jun 2009 02:01:06 +0200
Message-ID: <63386a3d0906241701o720fa667t662b9e3d4f080397@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Brian Swetland <swetland@google.com>:
> 2009/6/24 Daniel Walker <dwalker@fifo99.com>:
>> On Fri, 2009-06-19 at 17:13 -0700, Arve Hjønnevåg wrote:
>>>
>>> These are mostly questions for the framework team. The binder driver
>>> is there to support our user space code. At some point we used the
>>> driver from www.open-binder.org, but we ran into, and fixed, a lot of
>>> bugs (especially when processes died), so we determined it would be
>>> faster to rewrite the driver from scratch.
>>
>> Is there someone in your framework team that would be willing to respond
>> to these questions ? (I know you added hackbod to the CC, but they
>> aren't responding..)
>
> I guess it depends on the questions -- for good or ill, it's what is
> in use and replacing it with a different mechanism would be a pretty
> huge effort that there's unlikely to be time for in the near future.
> Quite a bit of the userspace framework depends on the binder handling
> the remote reference counting, object lifespan, etc, stuff and it's
> subtle and hairy to debug.  Moving to a different transport is
> possible (it's just software, as they say), but there's a lot of code
> that depends on the behavior that exists today.

What is nice about binder is that is steps in an fills the gap for rapid
buffer-passing IPC, is it really not possible to find common ground
with a D-Bus in-kernel IPC driver now that you're anyway using both
mechanisms and benefiting to both ends?

What I really want to know, is how this relates to the vmsplice() and
other zero-copy buffer passing schemes already in the kernel. I was
sort of dreaming that D-Bus and other IPC could be accelerated on
top of that.

Yours,
Linus Walleij
