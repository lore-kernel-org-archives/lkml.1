Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZCWIvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZCWIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZCWIvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:51:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64635 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZCWIvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VkL4twhpDlInKuTGv81rkD5TBjYT0Ed+Sdx+H0NiKALHCRdKMgPyNhbOh4G2Dy05Vv
         YZucBUSApJtf9m+VP/tMIIeUiM0o2G+9bPwMCt1BwVbcfqAWiDAwI20tBVerEpUfrNLY
         UMiInn4xaz/pad5/WIHAhxzuseSoZM08eyXTU=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0903222124580.7175@swampdragon.chaosbits.net>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
	 <alpine.LNX.2.00.0903222124580.7175@swampdragon.chaosbits.net>
Date: Mon, 23 Mar 2009 09:51:14 +0100
Message-ID: <2d05c4580903230151n20c8fc7kb47a5e2bb2480591@mail.gmail.com>
Subject: Re: Test some kernel feature without recompile
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 9:29 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sun, 22 Mar 2009, Dragoslav Zaric wrote:
>
>> Hi,
>>
>> I know when you work on some kernel module, you can change code and load
>> module again and test it, but what if you change some built in kernel
>> .c file, why
>> would I need to recompile whole kernel just to see what happens if I change one
>> .c file ??
>>
> Depends on the nature of the change. Some changes will ripple through the
> whole kernel.
> If, for example, you made a change to kmalloc() so that it takes an extra
> argument, then obviously all call sites would need changing and since
> kmalloc is used almose everywhere, then almost all files would need to be
> recompiled.
> But if your change is entirely contained to a single file, then 'make'
> will already ensure that only that file is rebuilt when you run 'make'
> (you'll still have to re-link the kernel or module though and a reboot
> will still be needed).
>
>> Why can I just compile one changed .c file and copy it where compiled version of
>> that file reside inside kernel tree?
>
> 'make' should already handle that for you. In what way does it not?
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>
>
