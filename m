Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbXHRTuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbXHRTuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXHRTtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:49:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:32369 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbXHRTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hFIJu2HDVrl4Nl174epkXJQsq7FwQO2EQJ51lMyXWEVlkrJr6uolo8aiOraVfjFt5vdqrHVZLe6RjqC8l1if4oE4xqNEPONATSuJjSiax74JPclHBJtp+bVgX5zQfsUHYjRLF5uVo0F76jkaDwmP7lqIOE7AoX/GMooeAP2Gzj4=
Message-ID: <ab40e9c0708181249l7389c300sd68964e22bf262a9@mail.gmail.com>
Date: Sat, 18 Aug 2007 21:49:50 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: how to add debug information into the vmlinux
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490708171430u2be506canf640d5c8c97149c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com>
	 <9a8748490708171430u2be506canf640d5c8c97149c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

I tried as what you told me. and the vmlinux does contain debug
information. but the start address of this vmlinux is 0xc0008000. when
I tried to run this vmlinux, the program always exit at 0x80a0. I
checked out that here is the place mmu is turned on.
so I used objcopy --change-addresses 0x40000000 to change the start
address of the vmlinux, and the program goes further.but the debug
information disappeared.

how to handle this? (making the program running and debug information available)

thanks,

regards,

yang

2007/8/17, Jesper Juhl <jesper.juhl@gmail.com>:
> On 17/08/07, Xu Yang <risingsunxy@googlemail.com> wrote:
> > Hello everyone,
> >
> > I am trying to port kernel 2.6.19 onto my system.so I need the c code
> > , which can show me where the program is running. I add -g when I
> > compile it.
> >
> You shouldn't need to do that manually, simply go into "make
> menuconfig", enter the "Kernel hacking" menu and select the "Kernel
> debugging" and "Compile the kernel with debug info" options.
> You may also want to enable "Compile the kernel with frame pointers"
> and various other options in that menu to get more debug info.
>
>
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>
