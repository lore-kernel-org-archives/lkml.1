Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZKUSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZKUSCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZKUSCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:02:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47545 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbZKUSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:02:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NthBLIxXouIRdGHbse9iddU0z9CWHGC9YeYI9qpLoSunHoqghWhgwNTyexbuoKen0b
         vCDtTlolEzoDgkf+OB+PzwxLo8P1+c2AePQ4mYip5PLY4y6Es2QjwPFy7/bzo9VBhoCo
         RcRZHZNCNLc6zSqkxW03bS40rzwJIlvBKYk7c=
MIME-Version: 1.0
In-Reply-To: <12a0d5b0-698a-40c5-8097-58a145acda12@x31g2000yqx.googlegroups.com>
References: <12a0d5b0-698a-40c5-8097-58a145acda12@x31g2000yqx.googlegroups.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 21 Nov 2009 13:02:05 -0500
Message-ID: <3e8340490911211002r3e0646aaqaa971b5ef7b6fdb4@mail.gmail.com>
Subject: Re: Hibernating under Linux ...
To: Albretch Mueller <lbrtchx@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 7:49 AM, Albretch Mueller <lbrtchx@gmail.com> wrote:
>
> One of the few things I think Windows does well (well, definitely
> better than "us") is hibernating. You can actually notice how the hard
> drives don't seem to be powered and even the fans stop spipping
>
> I have tried hibernating under both, knoppix 6.2 and Ubuntu 9.10 and
> none of them get it right. Is there any Linux distro that does?
>
> Why is that?

Both suspend-to-ram and suspend-to-disk result in fan and hard drive
poweroff on my hardware (dell inspiron 1420 laptop running ubuntu
9.10). It would be easier to help you if you gave details on your
hardware, and how you're triggering the suspend.

I should note that knoppix (or any other livecd distro) won't be
capable of suspend-to-disk (hibernation as windows calls it);
hibernation involves saving all state to disk and doing a full power
off, and when the whole point of the distro is to _not_ use the disk,
you clearly can't do this. Suspend-to-ram should work however, and on
most hardware should power down the hdd and fans.
