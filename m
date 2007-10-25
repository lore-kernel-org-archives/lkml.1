Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXJYVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXJYVa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXJYVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:30:13 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:31773 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbXJYVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rn9eYsWxID0N1aVDI8dVvTkS0yvQj0KxJnwRPfwz3TUMbZGwzuPBoSGJQ+0wdSnx2jG4w2o7BHL8EaIYW4hRvMwFA7uxk7WFaAcCavdmA/5I7IpxaI48Ua8+Hvzy7Xfne+MiLPt5hCi1gUXBdMaawexy897fgePo0jQyFXeaspI=
Message-ID: <fc94aae90710251430s669418e5v72282ff5f8a5691e@mail.gmail.com>
Date: Thu, 25 Oct 2007 22:30:09 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: Possibility of adding -march=native to x86
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4720FF2B.9020802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	 <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
	 <20071025185022.GP30533@stusta.de>
	 <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
	 <20071025191723.GQ30533@stusta.de>
	 <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
	 <20071025195020.GS30533@stusta.de>
	 <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
	 <4720FF2B.9020802@googlemail.com>
X-Google-Sender-Auth: c96f34e1baf0d175
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2007, Gabriel C <nix.or.die@googlemail.com> wrote:
> Michael Lothian wrote:
> >> The MPENTIUM4 option does not only set -march=pentium4, it also enables
> >> several other options in arch/i386/Kconfig.cpu resulting in better
> >> performance.
> >
> > How about an autodetect to set the right options here too using cpuid?
> >
> > With a warning of course that the code produced will be specifically
> > for the native cpu that it's compiled on.
>
> And kill off all Distro kernels right ? IMO to set that auto magically is bad.
>
> Regards,
>
> Gabriel
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Yes for something like a distro kernel it is bad but as I said before
this isn't what this is for.

Eventually it would be nice to to a make localkernel and for a
customised kernel to be build compiling in all pci / pci express
drivers into the kernel and all usb devices as modules.

Auto magically detecting the cpu would be part of that

I hate getting a new piece of kit and then have to figure out from
lspci which options need to be turned on and the the really iritation
part of finding the option in make menuconfig

Detecting the cpu and using march=native could be all part of that

Mike
