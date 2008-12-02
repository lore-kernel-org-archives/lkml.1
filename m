Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYLBWBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYLBWBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYLBWB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:01:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYLBWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:01:28 -0500
Message-ID: <4935B00D.5010302@redhat.com>
Date: Tue, 02 Dec 2008 23:00:45 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: pavel@suse.cz, jonsmirl@gmail.com, jrm8005@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
References: <AqQThtpZjFB@christoph>
In-Reply-To: <AqQThtpZjFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>> Can we merge the common ones into the kernel, while still keeping the
>> obscure ones in userspace using uinput or something?
> 
> Why do you want to complicate things even more.

Reality check please.  It already is that complicated.  We have IR
kernel drivers today.

> The decision to include some IR support using the Linux input layer some  
> time ago has forced *me* to add support for this in LIRC and explain to  
> people why for some devices they need LIRC drivers, and for some they need  
> the kernel drivers, and for other configurations they have to explicitly  
> disable the kernel drivers and replace them by LIRC drivers, etc.

The only way to get out of this situation long-term is to get advanced
IR support into the mainline kernel.

It doesn't matter how that actually looks like.  Could be pretty much
like todays lirc drivers.  Could be some input layer extention for
receiving/sending raw IR codes.  Could be something completely different
such as using the tty layer for that.  That has to be discussed and
agreed on.

What *does* matter is being in mainline.  lirc not being in mainline was
*the* major reason for me to use the input layer to handle TV card IR
support.  Having a in-tree driver depending on a out-of-tree subsystem
for IR is a major pain.

It is certainly a good thing to have only *one* way to handle IR
remotes.  But the kernel side of that way *must* be in mainline.
Everything else simply isn't going to fly.

cheers,
  Gerd


