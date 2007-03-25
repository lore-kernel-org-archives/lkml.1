Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXCYJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXCYJLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXCYJLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 05:11:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:36187 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933273AbXCYJLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 05:11:45 -0400
Date: Sun, 25 Mar 2007 11:16:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
In-Reply-To: <82e4877d0703242235r7c83a867hd4f3ec740e8627fb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703251113390.21880@jikos.suse.cz>
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop> 
 <200703250115.02029.dtor@insightbb.com>  <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
  <200703250129.32877.dtor@insightbb.com> <82e4877d0703242235r7c83a867hd4f3ec740e8627fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Parag Warudkar wrote:

> > > Yes this is a USB keyboard. Any hint as to where I should start 
> > > looking to make the driver not emit input event for keycode==0?
> > Was it always doing that? I'll add Jiri Kosina to the CC list as he's 
> > involved with HID now.
> Something (some keypress?) triggers it (by default it doesn't happen 
> immediately after a boot) - but once it starts it doesn't seem to stop 
> printing.

First, is there any specific kernel version where this started to happen 
to you, or is this long-standing bug you have been experiencing with older 
kernels too?

It would be useful if you could compile your kernel with CONFIG_HID_DEBUG 
and send the output both from the time the keyboard is connected and also 
when things go wild.

-- 
Jiri Kosina
