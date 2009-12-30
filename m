Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZL3CFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZL3CFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 21:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZL3CFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 21:05:45 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64164 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZL3CFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 21:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ca04mUn0/Crvk1X6NpnwCVOmiNP5WD1BlBHWoUUl5xQ33flbcNVL1/EKRV/WNKCwHc
         wldT/Bzfaox+sYOKI2A2Wal9IvyKjI8pTkzr1KVFYi3kRB3T+CgHcpEnNpShCKnnUb+/
         9Vo6G7qG8CaMSUfBJqdtCPbhxxKMyo6V6JuAY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912292002370.6803@localhost>
References: <alpine.LFD.2.00.0912291929010.6325@localhost>
	 <20091230115610.c10599b8.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.0912292002370.6803@localhost>
Date: Tue, 29 Dec 2009 21:05:42 -0500
Message-ID: <ea6602020912291805l2a1bd85cx9af7a4312aabfa17@mail.gmail.com>
Subject: Re: [PATCH] Remove macro MAXHOSTNAMELEN from <asm-generic/param.h>.
From: Vikram Dhillon <dhillonv10@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with you, the only place this macro is being used in glibc,
there are some really nice packages like MATLAB that depend on it, but
in distributions like Solaris there are conflicts in the newer version
and glibc so the trend seems to be moving away from glibc dependency
because of those conflicts. We might more of packages moving away from
glibc so let's wait and see what happens next :D

Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds



On Tue, Dec 29, 2009 at 8:03 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> On Wed, 30 Dec 2009, Stephen Rothwell wrote:
>
>> Hi Robert,
>>
>> On Tue, 29 Dec 2009 19:32:15 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>> >
>> > Since nothing in the entire tree makes use of this macro, remove
>> > it. This removal should eventually propagate to all of the
>> > arch-specific param.h files.
>>
>> Except if the only place this is picked up by glibc is the kernel
>> header files, then it will disappear from user mode and some
>> packages may break.
>
>  true, but this still takes me back to my original observation -- why
> is this macro being defined in a kernel header file if the kernel
> itself has absolutely no interest in it and doesn't use it in any way?
>
>  if glibc wants it, it might as well define it.
>
> rday
> --
>
>
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
>
>            Linux Consulting, Training and Kernel Pedantry.
>
> Web page:                                          http://crashcourse.ca
> Twitter:                                       http://twitter.com/rpjday
> ========================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
