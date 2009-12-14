Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZLNRe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZLNRe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZLNRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:34:56 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45942 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZLNRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vH+Mo814l9EswaP0HvEhrhO0kloIVGOPi+45nl2bX2bYduYjYGQsUJFCZk6fyz63nN
         ZgqVz7QTpD5VvqiYbuJ1hBqqTd/yUodH+G/WebBj0T+YJXMJQuSMNCAlRLHPvBboAOJO
         E9Eksx1SrdUafO/+lxbpf0KOSFZcx4P4l/I5U=
Date: Mon, 14 Dec 2009 09:34:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091214173450.GB2373@core.coreip.homeip.net>
References: <20091214014828.GA28402@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214014828.GA28402@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Sun, Dec 13, 2009 at 06:48:28PM -0700, Alex Chiang wrote:
> Hi Dmitry,
> 
> I just got a shiny new piece of hardware (HP Envy 15) with a
> Synaptics touchpad, and I can't seem to make the touchpad work
> correctly.  In this version of the touchpad, there are actually
> two physical buttons underneath the pad. In essence, this is a
> touchpad that you can click too.
> 
> I can't get the clicking to work. Of course, I can tap to click,
> but lacking access to the physical buttons means that I can't
> right-click.
> 
> Currently, I'm not sure if this is a driver issue or perhaps
> something higher up the stack, perhaps in X or maybe pilot error.
> ;)
> 
> Distro is Ubuntu Karmic, kernel is latest upstream last pulled on
> 13 Dec.
> 
> Would like some pointers on how to get started debugging.
> 
> Thanks,
> /ac
> 
> dmesg snip:
>  Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>  brd: module loaded
>  loop: module loaded
>  input: Macintosh mouse button emulation as /devices/virtual/input/input3
>  [...]
>  Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
>  input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input10
> 

Hmm, that's the new Synaptics "clickpad"... Takashi Iwai just posted a
coupleof patches for it on the input mailing list.

-- 
Dmitry
