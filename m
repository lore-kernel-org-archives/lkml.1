Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYG1PAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYG1PAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYG1O7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:59:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:27769 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYG1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B3DyTD2y/lk1LXI3nfa0Tvx3u5xHsMKNBTlCRTX1RD2W8ahQWdRleGq4YADq9wRZki
         Lj3a3DERKS5zGMPUhojPCHUW1u1sulaeZ0XqPaW4BvULJOnhbQ/qoTINopPF44fk7uyY
         aHYdpmvJqj1g6M+lRGa7Y/rg/WNSHF50iGPzs=
Message-ID: <5d6222a80807280759x5b2511c5t1743ff2a63046429@mail.gmail.com>
Date: Mon, 28 Jul 2008 11:59:52 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [Bisected] Regression: Hang on boot in schedule_timeout_interruptible during ACPI init on SMP
Cc: "Andrew Drake" <zappacky.lists@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080728141533.GA3697@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4887B4D5.1050306@gmail.com>
	 <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
	 <488B7297.8090405@gmail.com> <20080728141533.GA3697@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:15 AM, Glauber Costa <gcosta@redhat.com> wrote:
> On Sat, Jul 26, 2008 at 02:53:11PM -0400, Andrew Drake wrote:
>> I just discovered; the nolapic_timer parameter causes the problem to go
>> away entirely. It doesn't seem to have any nasty side effects, so I'm
>> content to use it. Looking at the dmesg logs, however, I notice that the
>> "last-good" kernel doesn't even try to use the LAPIC timer, but the
>> "first-bad" does. I wasn't able to track down any discernible reason.
> fine, but if you can still help us on this, it would be awesome ;-)
>
> Actually, there is another nasty bug that depends, at least by a first
> impression, on the lapic timer. I'm planning to save a time today to
> look further on your problem.
>>
>> On a side note, that's the first I've ever heard/seen of that parameter,
>> I tried it because I noticed the problems started when the LAPIC timer
>> was successfully set up. I doubt the average user would notice this (you
>> can't even tell unless you pass apic=debug), so I doubt many others would
>> discover this fix/workaround.
>>
>> The question remains, though, why did it go from "don't try" to "try"?
>
> Probably because the order of initialization of smp entities changed a
> bit during this series. Probably the lapic timer is now initialized a
> little bit earlier, before we have the chance to mark it as bad.
>
> If you can send me at least your dmesgs and cpuinfo, it would be really really
> awesome.

Just saw you've already done it.

Will look through it.

many thanks
>> Thanks,
>>
>> Andrew
>>
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
