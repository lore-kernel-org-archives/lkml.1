Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZGNJLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZGNJLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZGNJLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:11:38 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:63883 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZGNJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YmzieWk4LHN8oI4cSTf82wr/ZjwgJMr2nzbsog4/2Tlatq7owYFdSM5apni8ar+GwA
         4WHFHKal5PFuR2j5qVyKAkRMzBaCInLtNGSBqUFKRrrXeAel1dfh4YuuwrZtHSFnFAGD
         Kud2hiaX21LnH30nhICfO2/XaOzimrF9ZMYt4=
MIME-Version: 1.0
In-Reply-To: <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
References: <4A04E5EA.7000103@samsung.com>
	 <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
	 <20090511031208.GA15208@dtor-d630.eng.vmware.com>
	 <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com>
	 <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
	 <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
	 <4A5BF6F0.6020403@samsung.com>
	 <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
	 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
	 <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
Date: Tue, 14 Jul 2009 14:41:36 +0530
Message-ID: <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
From: Trilok Soni <soni.trilok@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Jul 14, 2009 at 2:37 PM, Marek
Szyprowski<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Tuesday, July 14, 2009 10:25 AM, Dmitry Torokhov wrote:
>
>> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
>> > Hello,
>> > On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
>> > > Dmitry Torokhov wrote:
>> > > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
>> > > >> I don't see this driver picked up yet in your -next branch. We should
>> > > >> target this driver to be mainlined in next merge window. This is very
>> > > >> important driver for some of the embedded systems, including palm pre
>> > > >> :)
>> > > > I was wondering if somebody could test the patch below and if it still
>> > > > works then I will apply to the next branch. Thanks!
>> > > >
>> > >
>> > > Dear Marek,
>> > >
>> > > Because I don't have the NCP board(which includes the max7359 keypad)
>> > > now, I can't test this patch. Marek, could you please test this patch?
>> >
>> > I would like to, but I could not find the base version to which I can apply
>> > that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
>> > switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
>> > posted in replies to that main, but the latest patch still fails to apply.
>> >
>> > Could someone send me a complete patch, so I can do a test?
>> >
>>
>> Sending everything as attachments, maybe that will help...
>
> Ok. I've did the tests.
>
> MAX7359 keypad driver works after your patch, but reports much more events than
> the previous version. In this test I pressed quickly the first button on the
> keypad.
>
> Old version:
> NCP:~# hexdump /dev/input/event0
> 0000000 0037 0000 e733 000b 0001 00e7 0001 0000
> 0000010 0037 0000 e748 000b 0000 0000 0000 0000
> 0000020 0037 0000 94e2 000d 0001 00e7 0000 0000
> 0000030 0037 0000 94f3 000d 0000 0000 0000 0000
>

Please use evtest instead. It will give better output atleast.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
