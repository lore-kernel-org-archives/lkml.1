Return-Path: <linux-kernel-owner+w=401wt.eu-S1030698AbXCCRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698AbXCCRlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030700AbXCCRlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:41:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030698AbXCCRlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:41:44 -0500
Date: Sat, 3 Mar 2007 09:41:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Message-Id: <20070303094125.838ce04d.akpm@linux-foundation.org>
In-Reply-To: <45E99A45.9030506@gmail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<45E996A0.6070700@gmail.com>
	<45E99A45.9030506@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 16:54:45 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> 
> 
> Jiri Slaby napsal(a):
> > Andrew Morton napsal(a):
> >> Temporarily at
> >>
> >>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Weird behaviour of numlock and capslock on USB keyboard in X. After 
> 
> Hmm, it's not X related. Console behaves similarly.
> 
> > pressing
> 
> Or actually if some script tries to change LEDs (logout).
> 
> > those keys, keyboard "hangs" -- no sysrq, no lock leds are flashing.
> > 
> > After plug; unplug of the keyboard, it works unless I press the keys
> > again.
> > 
> > There is nothing in dmesg. X log says
> > (II) evdev brain: Rescanning devices (3).
> > (II) evdev brain: Rescanning devices (4).
> > (II) evdev brain: Rescanning devices (5).
> > (II) evdev brain: Rescanning devices (6).
> > (II) evdev brain: Rescanning devices (7).
> > (II) evdev brain: Rescanning devices (8).
> > (II) evdev brain: Rescanning devices (9).
> > (II) evdev brain: Rescanning devices (10).
> > (II) evdev brain: Rescanning devices (11).
> > (II) evdev brain: Rescanning devices (12).
> > (II) evdev brain: Rescanning devices (13).
> > (II) evdev brain: Rescanning devices (14).
> > in this kernel, but I don't know if this is relevant.
> > 
> > After booting back to .20-mm2 everything is OK.
> 

Thanks.  Cc's added.
