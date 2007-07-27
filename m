Return-Path: <linux-kernel-owner+w=401wt.eu-S938420AbXG0XEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938420AbXG0XEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937623AbXG0XEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:04:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:35536 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937513AbXG0XEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SJqrbzbcJo4p7f5KjbDhcCOk0wNYjyS8+1lRNpKgh8krW7uM237P1cgvEQI0PWjWU5bn3FanUp6Qohu42QsuLayZxdzq51XMD1b1MPAHCGp5b2URk1kx40+bOxt/crzg5uC8guauBI5x5Ofwf7hYet5AdX+XeV+FoF2KHS+X5/c=
Message-ID: <9a8748490707271604x45ad26e2te8082b5f64504ad2@mail.gmail.com>
Date: Sat, 28 Jul 2007 01:04:30 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: shacky <shacky83@gmail.com>
Subject: Re: Kernel modules compilation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7fedbc910707271552x71010f82o8455c17b21f80eab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
	 <9a8748490707271303h7f5187ffk31d211c34fd885bf@mail.gmail.com>
	 <7fedbc910707271438t183bab6bxe295f161a5ec0fba@mail.gmail.com>
	 <9a8748490707271542s13862269h79f85d4171233f47@mail.gmail.com>
	 <7fedbc910707271552x71010f82o8455c17b21f80eab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, shacky <shacky83@gmail.com> wrote:
> > Symbol: USB [=y]
> > Prompt: Support for Host-side USB
> >   Defined at drivers/usb/Kconfig:51
> >   Depends on: USB_SUPPORT && USB_ARCH_HAS_HCD
> >   Location:
> >     -> Device Drivers
> >       -> USB support (USB_SUPPORT [=y])
>
> Could you tell me how you found them, please?
>

Some of them I just knew from past experiences where to find, some of
them are logical (like, obviously 'reiserfs' is found in the
Filesystems submenu), some I searched for using "/" and a few I
googled.

> > Hint: In menuconfig, type "/" to search.
>
> Thank you very much!
>
You're welcome.  By the way; if you had taken the time to read the
text at the top of the menuconfig interface you'd have known this
already - "... Press <Esc><Esc> to exit, <?> for Help, </> for
Search."

> > Not really. Your distribution could be loading a ton of modules that
> > you don't really need. 'lsmod' will just show you what is currently
> > loaded, but that that doesn't necessarily mean that all those modules
> > are really needed.
>
> Ok, how I can know what modules are needed and what not? Only knowing
> the hardware of my system?
>
If you know the hardware of the system, the filesystems you use etc
etc, then it should be possible to deduce what modules you need...
Read the help text for each config option related to your modules and
think about whether or not you need it...

> Another question please, what the symbol "---" near a kernel
> configuration entry in menuconfig means? This entry is activated (with
> * or M) or not?
>
It means that the option was automagically selected by some other
option you selected, so you can't disable it unless you first disable
that other option that selected it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
