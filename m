Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZCDBin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZCDBin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZCDBif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:38:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:9810 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZCDBif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z157DLAlZlWJsIaf8zxcC9+EKVAV1N/ePAl0X6weqzz8zRcwSrZcAN6CyS+ub6yE38
         JTflAlra+0aljp1/q9GUbAH5So8uqATZLnvEuh0qsbylrvYkk3T6LR52CNcPZXqhsorc
         5HNa65R8p+ClYisrXNZHAhNB9sg3wE1DcOFaU=
MIME-Version: 1.0
In-Reply-To: <43e72e890903031607k4e2ce36csb7c48de2f01a6de6@mail.gmail.com>
References: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>
	 <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>
	 <49AD17DD.1030206@gmail.com>
	 <43e72e890903031607k4e2ce36csb7c48de2f01a6de6@mail.gmail.com>
Date: Tue, 3 Mar 2009 17:38:32 -0800
Message-ID: <43e72e890903031738w12a726d4ga3f998d8e4263a73@mail.gmail.com>
Subject: Re: hid-dummy.ko Input/output error -- causing huge delays
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 4:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Mar 3, 2009 at 3:43 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 3.3.2009 02:51, Luis R. Rodriguez wrote:
>>>
>>> On Mon, Mar 2, 2009 at 5:37 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>  wrote:
>>>>
>>>> FATAL: Error inserting hid_dummy
>>>> (/lib/modules/2.6.29-rc6-wl/kernel/drivers/hid/hid-dummy.ko):
>>>> Input/output error
>>>>
>>>> I remember reading a thread where you said this was non-fatal and that
>>>> hid-dummy.ko would go away. On my system, every now in a blue moon the
>>>> above causes a huge delay during the bootup sequence. I'm talking
>>>> about a full 1-2 minute delay. Why is the delay so sporadic?
>>>
>>> s/once in a blue moon/often/
>>>
>>> as it seems I get this now upon every reboot.
>>
>> So I suppose the problem goes away, when you change -EIO to 0 in
>> drivers/hid/hid-dummy.c
>
> Yeap.

Well now I see FC10 say its starting udev and it just sits there
waiting for the same period of time so maybe it was that (?). But at
the console the hid-dummy is not the last message I see now, but I
guess I wouldn't because it returns 0 now huh.

  Luis
