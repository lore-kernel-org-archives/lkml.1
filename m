Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXLTAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXLTAEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXLTAEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:04:33 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:6051 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXLTAEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:04:33 -0500
Message-ID: <1a9da18c0712191604u5a230382t5ad99a6f464416e5@mail.gmail.com>
Date: Wed, 19 Dec 2007 16:04:30 -0800
From: "=?UTF-8?Q?Masoud_Sharbiani?=
	=?UTF-8?Q?_\"=D9=85=D8=B3=D8=B9=D9=88=D8=AF_?=
	=?UTF-8?Q?=D8=B4=D8=B1=D8=A8=DB=8C=D8=A7=D9=86=DB=8C\"?=" 
	<masouds@masoud.ir>
To: "Siva Prasad" <sprasad@bivio.net>
Subject: Re: printf internals
Cc: "Scott Russell" <catfather@donpoo.net>,
       "Clemens Koller" <clemens.koller@anagramm.de>,
       "David Newall" <david@davidnewall.com>, linux-kernel@vger.kernel.org
In-Reply-To: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF56B@corpexc01.corp.networkrobots.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com>
	 <4761E289.9070007@davidnewall.com> <4762AC35.3010706@anagramm.de>
	 <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF540@corpexc01.corp.networkrobots.com>
	 <1198107085.7740.0.camel@oasis.donpoo.home>
	 <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF56B@corpexc01.corp.networkrobots.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, Siva Prasad <sprasad@bivio.net> wrote:
>
> Yes!... this is a embedded system, and will not have monitor. So, serial
> is the default console.
>
> I pass cmdline as "root=/dev/ram rw console=ttyS0,115200"

Adding a CONSOLE=/dev/ttyS0 works for me on both Debian and Redhat;
You also want a inittab entry for console on serial device. (use
google and find it yourself).
cheers,
Masoud

> Thanks
> Siva
>
>
> -----Original Message-----
> From: Scott Russell [mailto:catfather@donpoo.net]
> Sent: Wednesday, December 19, 2007 3:31 PM
> To: Siva Prasad
> Cc: Clemens Koller; David Newall; linux-kernel@vger.kernel.org
> Subject: RE: printf internals
>
>
> On Wed, 2007-12-19 at 14:33 -0800, Siva Prasad wrote:
> > Thank you very much for your response Clemens.
> >
> > I tried strace on a regular system. It does not show which tty, etc.,
> as it uses the stdout (fd = 1) and write(1, ...) to it.
> >
> > This is not a student project. I am trying to build my own kernel and
> ramdisk. Kernel boots fine to a point where it starts accessing ramdisk
> and executes init scripts. From there on nothing gets printed. I did
> some debugging and found that prints of user land programs are not
> coming to the serial console, while kernel prints are working fine. I
> found all the programs getting executed, by placing a printk in execve
> routine and printing the arguments.
> >
> > So, I wanted to trace down the path from user program to the kernel
> and see why it is not printing messages from user program. I placed a
> printk in drivers/char/tty_io.c:tty_write() and it is not getting called
> from my file system. I tried the same thing on my good system (say
> regular PC) and it works as expected.
> >
> > Any clues that can help debug this issue is highly appreciated.
> > How can I get access to the same printf string inside kernel.
>
> This sounds like you're printing out the serial console instead.
>
> --
> Scott <catfather@donpoo.net>
> AIM: BlueCame1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
