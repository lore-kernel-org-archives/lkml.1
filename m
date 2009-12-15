Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbZLOOwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbZLOOwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZLOOwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:52:47 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:53469 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZLOOwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MsIqPP9dIxqwTBqoEHw4huTaU0wIJqPfYL8+5emUqeNDaBbp6Br+t5mE+xnVkCutLb
         a6THPD7OTSG59hDVKn4KHn1pN7bazpjCaXWeYsXADxN02XTLi40XqJjjS4C3NixDPBU6
         sXByL/RCOFDQsOM2TzcAJ8p8zhrE/AiCfso38=
MIME-Version: 1.0
In-Reply-To: <20091215054004.GF587@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com>
	 <1260759123.3391.0.camel@localhost>
	 <20091214031127.GB29591@ldl.fc.hp.com>
	 <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com>
	 <20091215054004.GF587@ldl.fc.hp.com>
Date: Tue, 15 Dec 2009 09:52:42 -0500
Message-ID: <a728f9f90912150652p7fc1c2d8tc341e4c6f59e5346@mail.gmail.com>
Subject: Re: radeon 4830 corruption after resume
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, rjw@sisk.pl,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:40 AM, Alex Chiang <achiang@hp.com> wrote:
> Adding dri-devel to cc as I should have done in the first place.
>
> Full thread for context here: http://lkml.org/lkml/2009/12/13/321
>
> More responses below.
>
> * Xiaotian Feng <xtfeng@gmail.com>:
>> On Mon, Dec 14, 2009 at 11:11 AM, Alex Chiang <achiang@hp.com> wrote:
>> > * Dave Airlie <airlied@redhat.com>:
>> >> On Sun, 2009-12-13 at 19:30 -0700, Alex Chiang wrote:
>> >> > Hi Dave, Rafael,
>> >> >
>> >> > I can successfully suspend/resume my HP Envy, but upon resume,
>> >> > the screen is corrupted.
>> >> >
>> >> > I used the gnome screenshot utility to capture this:
>> >> >
>> >> >     http://chizang.net/alex/tmp/radeon-4830-corruption.png
>> >> >
>> >> > But that screenshot leads you to believe the corruption was
>> >> > 100%, when in reality, the text in my xterms was at least
>> >> > readable, but ugly.
>> >> >
>> >> > Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.
>> >>
>> >> Has it ever worked? can you suspend/resume without X running at all?
>> >
>> > Hm, define "worked"?
>> >
>> > The machine responds to keyboard, mouse, network input, etc. It's
>> > just that the screen is garbled.
>> >
>> > Unless I'm not understanding what you're asking?
>> >
>> >> Its quite possibly a userspace problem but its hard to know, we
>> >> haven't changed the user modesetting pieces in the kernel at all in
>> >> quite a while.
>> >
>> > Ok, I'm just looking for where/how to start debugging. Any advice
>> > on where to look next would be fine too.
>>
>> Then how about ssh to your machine, and get dmesg output?
>
> The machine is actually useable. Wireless networking even works.
> It's just that the screen is garbled.
>
> Here's a much better idea of the type of corruption that I'm
> seeing. Huge file alert, it's like a 5MB jpg.
>
>        http://chizang.net/alex/tmp/corrupt-radeon2.jpg
>
> I'm attaching full dmesg and pm-suspend.log.
>
> The suspend happens some time around time 400 and the resume is
> the huge jump in time afterwards.

As Dave asked previously, is this a regression?  I.e., did s/r work at
some point in the past and if so when?

Alex
