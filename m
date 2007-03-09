Return-Path: <linux-kernel-owner+w=401wt.eu-S1767305AbXCIONc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767305AbXCIONc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767306AbXCIONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:13:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:37840 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767305AbXCIONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kq0Wm2xTQZkuMITHGnQbFaM6XgDqFYOislgMfZaAADl0MKBR0JV57DaG81cY4TrghtJIUjvwdR1Wcyy1jT1PYFWuE1AONi8+kWdOJ/wRC3HlB4LUxrnQMsWaae5TfEKWvhHRw0lRTpiqkZpY9uhi/qYAIh5S0kkx0Cj+bAF4IfI=
Message-ID: <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
Date: Fri, 9 Mar 2007 09:13:28 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Richard Purdie" <rpurdie@rpsys.net>, "Jiri Kosina" <jkosina@suse.cz>
In-Reply-To: <45F13791.8040408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>
	 <20070303094125.838ce04d.akpm@linux-foundation.org>
	 <45F13791.8040408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Andrew Morton napsal(a):
> > On Sat, 03 Mar 2007 16:54:45 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> >>
> >> Jiri Slaby napsal(a):
> >>> Andrew Morton napsal(a):
> >>>> Temporarily at
> >>>>
> >>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> >>> Weird behaviour of numlock and capslock on USB keyboard in X. After
> >> Hmm, it's not X related. Console behaves similarly.
> >>
> >>> pressing
> >> Or actually if some script tries to change LEDs (logout).
> >>
> >>> those keys, keyboard "hangs" -- no sysrq, no lock leds are flashing.
> >>>
> >>> After plug; unplug of the keyboard, it works unless I press the keys
> >>> again.
> >>>
> >>> There is nothing in dmesg. X log says
> >>> (II) evdev brain: Rescanning devices (3).
> >>> (II) evdev brain: Rescanning devices (4).
> >>> (II) evdev brain: Rescanning devices (5).
> >>> (II) evdev brain: Rescanning devices (6).
> >>> (II) evdev brain: Rescanning devices (7).
> >>> (II) evdev brain: Rescanning devices (8).
> >>> (II) evdev brain: Rescanning devices (9).
> >>> (II) evdev brain: Rescanning devices (10).
> >>> (II) evdev brain: Rescanning devices (11).
> >>> (II) evdev brain: Rescanning devices (12).
> >>> (II) evdev brain: Rescanning devices (13).
> >>> (II) evdev brain: Rescanning devices (14).
> >>> in this kernel, but I don't know if this is relevant.
> >>>
> >>> After booting back to .20-mm2 everything is OK.
> >
> > Thanks.  Cc's added.
>
> Remains unsolved in 2.6.21-rc3-mm2.
>

Does a PS/2 keyboard behave for you?

Nowadays I forward all USB HID related issues to Jiri Kosina ;) (CCed).

-- 
Dmitry
