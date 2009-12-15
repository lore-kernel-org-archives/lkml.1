Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbZLOXIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbZLOXIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbZLOXIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:08:30 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48526 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761693AbZLOXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TFvpZanf9svYyGgTpeQvnM6DVaA+lz36imIulKTq3zHB6MpH9rSdYOzzz2ju3YLiHm
         75Sw2TTfGvrekzROly6BlfH0WnPtx5e1ozPsPeqYTZBwLXBNvru34Ap2Dp2Y99464aos
         RvMcEuu0fum2/fxtNDUkBSGfUnmp8I86Gp/FQ=
MIME-Version: 1.0
In-Reply-To: <586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com>
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com> 
	<586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com>
From: Younes Manton <younes.m@gmail.com>
Date: Tue, 15 Dec 2009 18:08:06 -0500
Message-ID: <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
Subject: Re: [drm] nouveau iMac crashes and burns
To: Justin Mattock <justinmattock@gmail.com>
Cc: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 6:02 PM, Younes Manton <younes.m@gmail.com> wrote:
> On Tue, Dec 15, 2009 at 5:54 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> I had figured this would happen,
>> but was curious to see if this
>> new bad boy would work.
>> (probably why fedora 12 doesnt boot as well).
>>
>> basically the system freezes during boot once
>> drn nouveau is loaded. here's dmesg captured
>> with firescope:(a bit long)
>
>  <..snip..>
>> <3>[    6.891531] [drm] nouveau 0000:02:00.0: No ctxprog for NV94
>  <..snip..>
>
>>
>> machine is an iMac with the gt130 card
>> I loaded mesa,dri, but didn't find any
>> firmware(if any) for /lib/firmware
>
> You need the firmware, it's not carried in the upstream tree.[1]
> There's also a PPC-specific patch currently in the Nouveau tree and on
> various lists that you need to apply.[2]
>
> [1] http://people.freedesktop.org/~pq/
> [2] http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=a51b847bebf85e8539db6afe1627a3a17a05dfcc
>

(You only need to apply [2] if yours is a PPC Mac in case it wasn't
obvious, I just assumed PPC for some reason...)
