Return-Path: <linux-kernel-owner+w=401wt.eu-S1750953AbZLNF2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbZLNF2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZLNF2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:28:38 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61580 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZLNF2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FvPLdI9+YjgIx00Oh+79WRT1IVxwFvw81IUMUDz8PqJ06QvP97MFN+ayV8dsC3+/e5
         bq1cmXn6xP8259wIofeh4OjfE1GW84Bytxn9THnVfjCi5tvNOBfJIUtZenys+T6LBj1u
         IBUQUHqbsvy6GAvTtwb+tqbi6bg3uQ4OfzFLI=
MIME-Version: 1.0
In-Reply-To: <20091214031127.GB29591@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com>
	 <1260759123.3391.0.camel@localhost>
	 <20091214031127.GB29591@ldl.fc.hp.com>
Date: Mon, 14 Dec 2009 13:28:35 +0800
Message-ID: <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com>
Subject: Re: radeon 4830 corruption after resume
From: Xiaotian Feng <xtfeng@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Dave Airlie <airlied@redhat.com>, rjw@sisk.pl,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:11 AM, Alex Chiang <achiang@hp.com> wrote:
> * Dave Airlie <airlied@redhat.com>:
>> On Sun, 2009-12-13 at 19:30 -0700, Alex Chiang wrote:
>> > Hi Dave, Rafael,
>> >
>> > I can successfully suspend/resume my HP Envy, but upon resume,
>> > the screen is corrupted.
>> >
>> > I used the gnome screenshot utility to capture this:
>> >
>> >     http://chizang.net/alex/tmp/radeon-4830-corruption.png
>> >
>> > But that screenshot leads you to believe the corruption was
>> > 100%, when in reality, the text in my xterms was at least
>> > readable, but ugly.
>> >
>> > Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.
>>
>> Has it ever worked? can you suspend/resume without X running at all?
>
> Hm, define "worked"?
>
> The machine responds to keyboard, mouse, network input, etc. It's
> just that the screen is garbled.
>

Then how about ssh to your machine, and get dmesg output?

> Unless I'm not understanding what you're asking?
>
>> Its quite possibly a userspace problem but its hard to know, we
>> haven't changed the user modesetting pieces in the kernel at all in
>> quite a while.
>
> Ok, I'm just looking for where/how to start debugging. Any advice
> on where to look next would be fine too.
>
> Thanks,
> /ac
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
