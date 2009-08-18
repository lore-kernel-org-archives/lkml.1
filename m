Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbZHRSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbZHRSrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZHRSra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:47:30 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41613 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZHRSr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jq8BCcNEemnNiNBrDra6WUdKkDEIGOuGR5vXJ318jSO/f+9HWQWIKRPiDdmcsuzxEG
         hgQFs4TAUBUaSZEg07akJQJlsvElfz/8fyUdTHBerWuFEEmiFKnU6pq3KJqd7J1YdXkM
         lGACmLoRHKcrbxSpcB5gUFcUcpZ/ZrarCdJyA=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <4A76E6AA.2040608@nets.rwth-aachen.de>
References: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
	 <4A76E3E8.30902@nets.rwth-aachen.de>
	 <11fae7c70908030624q11ffd29ened3c77ec4c4ca79a@mail.gmail.com>
	 <4A76E6AA.2040608@nets.rwth-aachen.de>
Date: Tue, 18 Aug 2009 21:47:28 +0300
X-Google-Sender-Auth: d1c92cb0f32c7bb6
Message-ID: <11fae7c70908181147k4384478crc9909ec8256db868@mail.gmail.com>
Subject: Re: x86 Geode issues in kernel >= 2.6.23 and >= 2.6.31-rc4
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 4:31 PM, Arnd
Hannemann<hannemann@nets.rwth-aachen.de> wrote:
> Martin-Éric Racine wrote:
>> On Mon, Aug 3, 2009 at 4:19 PM, Arnd
>> Hannemann<hannemann@nets.rwth-aachen.de> wrote:
>>> Martin-Éric Racine wrote:
>>>> (non-subscriber post; please keep me in CC)
>>>>
>>>> Greetings,
>>>>
>>>> Having previously reported two issues via Ubuntu's bug tracker and not
>>>> found any answer, I thought I'd approach the LKML with the issues at
>>>> stake.
>>>>
>>>> 1) Since kernel 2.6.23, one cannot boot hardware based on the Geode
>>>> SCx200 series. Partial answers about the most plausible cause have
>>>> been found by the target hardware's manufacturer as explained at
>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/241307
>>>>
>>>> 2) Since kernel 2.6.31-rc4, one cannot boot hardware based on the
>>>> Geode LX800 as described at
>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/396286
>>>>
>>>> In case either of these issues was already reported and there is a
>>>> know fix or work-around, I'd love to hear more. Otherwise, please feel
>>>> free to contact me for additional details.
>>>>
>>> Just to give a data point:
>>> 2.6.31-rc1,2,3,4,5 were/are running all fine on my Geode LX800
>>> (http://www.pcengines.ch/alix2d2.htm) so it seems something
>>> board or .config specific.
>>
>> Thank you for your answer, Arnd.
>>
>> Could you please send me a copy of your .config so that I can compare
>> it with the one used on Ubuntu kernels?
>
> Sure. Config for 2.6.31-rc5 is attached.

Could you try enabling CONFIG_FS_POSIX_ACL in your config and building
a new kernel? Does it still boot?

Martin-Éric
