Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZA0Whh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZA0Whh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZA0Wh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:37:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:8199 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZA0Wh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:37:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uRihzPfkfoZ3n5QBLoIOaclmVWXmDL78aW+EBfqyXILZ5X9vBYdZFotm3NYnI6RoW9
         ACUoeEf7yvzO/Sjh56zcScGZjnCHyHlTFwpV5MoAe1et1MtWCbfRacCVB/bU1U4FDjnM
         M1zxmsPKH47xMO5gc9v7MVV+Yp38BBFCj1jiE=
MIME-Version: 1.0
In-Reply-To: <20090127102421.06bfd4c1@caramujo.chehab.org>
References: <55fdf7050901261409h67f581f1ib6951ecb60eb8e8@mail.gmail.com>
	 <20090127102421.06bfd4c1@caramujo.chehab.org>
Date: Tue, 27 Jan 2009 14:37:23 -0800
Message-ID: <55fdf7050901271437o7afafa42j1db0fd18ca1ce915@mail.gmail.com>
Subject: Re: cx88 audio input change
From: LINUX NEWBIE <lnxnewbie@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux cx88 driver, is it possible to stream audio only without
video Risc engine running?  If so, what tools/players and commands can
I use to stream audio only from cx88 card?

I appreciate for all your help.
Hiep

On Tue, Jan 27, 2009 at 4:24 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> On Mon, 26 Jan 2009 14:09:31 -0800
> LINUX NEWBIE <lnxnewbie@gmail.com> wrote:
>
>> Hi Mauro,
>>
>>     You've been working on cx88 for a long time.  Can I ask you
>> something?  I have a cx88 based card and I tried to get audio coming
>> from "Line In" of my card.  However, it seems like the audio always
>> comes from TV input.   I looked into the code and it seems like
>> VIDIOC_S_AUDIO is not working in cx88.  Can you help please?
>
> The better is to ask such questions on linux-media@vger.kernel.org. Anyway, the
> issue is likely due to a wrong entry at cx88-cards for your board. In order to
> fix, someone with your board (probably you)should get the proper GPIO pins for
> your device. Please read the following wiki articles:
>
> http://linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device
> http://linuxtv.org/wiki/index.php/GPIO_pins
>
> Cheers,
> Mauro
>
