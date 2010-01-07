Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0AGUnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0AGUnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102Ab0AGUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:43:09 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:57333 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab0AGUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eTvxbvExXNUH19ene/jGrxXdiYIPhod/g/7lW2I7EwSQ0ITs7bdkRDnmqLvwy95aSb
         Xz+70Am/yMiBLky5rzdoa/MG/UZmBk4aaF8RJri/8ttnKM6HuuxaavVcwqb+AY07evsa
         ssqsVtb/2nPSR6P+Xi7ZUQTaZ18L2MrS0R3X0=
Message-ID: <4B464774.8020007@gmail.com>
Date: Thu, 07 Jan 2010 12:43:32 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook	pro
 to have an annoying whining sound
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> <20100107125433.GB13603@tuxdriver.com> <4B460188.1050504@gmail.com> <20100107203752.GA31726@tuxdriver.com>
In-Reply-To: <20100107203752.GA31726@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 12:37, John W. Linville wrote:
> On Thu, Jan 07, 2010 at 07:45:12AM -0800, Justin P. Mattock wrote:
>> On 01/07/10 04:54, John W. Linville wrote:
>>> On Wed, Jan 06, 2010 at 10:16:27PM -0800, Justin Mattock wrote:
>>>> for a while I've been hearing this odd
>>>> annoying sound coming from my macbook pro
>>>> when the system is idle(no internet use tv/radio/web etc...)
>>>> as soon as I do anything(radio,web) the noise disappears.
>>>>
>>>> here is a  url where they are experiencing the same issue:
>>>> https://help.ubuntu.com/community/MacBook1-1/Hardy
>>>> (down under whining noise);
>>>>
>>>> here is is the result of my bisect:
>>>>
>>>> 2d4c8266774188cda7f7e612e6dfb8ad12c579d5 is the first bad commit
>>>> commit 2d4c8266774188cda7f7e612e6dfb8ad12c579d5
>>>> Author: Michael Kerrisk<mtk.manpages@googlemail.com>
>>>> Date:   Mon Sep 22 13:57:49 2008 -0700
>>>>
>>>>      sys_paccept: disable paccept() until API design is resolved
>>>
>>> Any particular reason you sent this to linux-wireless??
>>>
>>
>>
>> because the bisect had resulted in
>> something with wireless, so I figured
>> it was the next best thing todo.
>
> Well, if you say so. :-)  But, I'm not sure I see the connection
> between sys_paccept and wireless...?
>
> John


yeah.. my bad..
I got too CC happy with this one.

I think andi is right by saying this
is a power management issue.

Justin P. Mattock
