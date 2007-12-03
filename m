Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbXLCBvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbXLCBvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXLCBve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:51:34 -0500
Received: from bay0-omc1-s4.bay0.hotmail.com ([65.54.246.76]:48526 "EHLO
	bay0-omc1-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbXLCBvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:51:33 -0500
Message-ID: <BAY113-W1985848D5BE4557BEB0998846C0@phx.gbl>
X-Originating-IP: [76.197.170.147]
From: Scott White <nwi_sub@hotmail.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.23.9, make install doesn't work with grub anymore??
Date: Sun, 2 Dec 2007 19:51:32 -0600
Importance: Normal
In-Reply-To: <20071201222720.23040d71@laptopd505.fenrus.org>
References: <BAY113-W62BC3D470D7BA8C731FF984730@phx.gbl>
 <20071201222720.23040d71@laptopd505.fenrus.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Dec 2007 01:51:33.0053 (UTC) FILETIME=[07DAD6D0:01C8354F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Sat, 1 Dec 2007 22:27:20 -0800
> From: arjan@infradead.org
> To: nwi_sub@hotmail.com
> CC: linux-kernel@vger.kernel.org
> Subject: Re: 2.6.23.9, make install doesn't work with grub anymore??
>
> On Sat, 1 Dec 2007 20:51:14 -0500
> Scott Noone  wrote:
>
>>
>> Hello,
>>
>> I downloaded the vanilla kernels 2.6.23.8 and 2.6.23.9 from
>> kernel.org. I unpacked them like I have every other kernel release.
>> I compiled the kernel successfully, did the make modules and make
>> modules_install with no problems. When I did the make install I am
>> told it Cannot find LILO. The message seems to come
>> from /usr/src/linux-2.6.23.9/arch/i386/boot/install.sh The script is
>> correct that I don't have lilo installed, I have used grub for quite
>> some time. I don't remember having this problem with older kernels,
>> sorry I don't remember one of the top of head. Did something change
>> or is: cp .config /usr/src/linux-2.6.23-9 make menuconfig make make
>> modules make modules_install make install no longer adequate to
>> compile and install a kernel?
>
> Hi,
>
> actually this isn't the fault of the kernel; the grub/lilo/etc stuff is
> done by a distro specific script that just gets called from make
> install...
>
> did you happen to change distros or update something like an
> initscripts or similar package recently?
>
> Greetings,
> Arjan van de Ven

Yes I just temporarily switched from Fedora to Slax for a medium sized project I am working on.  I wanted to stick with Fedora, but the requirements are forcing me to use Slax.

I assumed the problem was with the kernel since install.sh came with the kernel.org kernel.  Now this may be a silly question, but why is the install script distro specific?  I assumed that the install script would be modular like the kernel.  If a new bootloader came out, just add a module.  Please keep in mind I have no knowledge of the kernel internals.  I just compile and go.

Thanks,
Scott

_________________________________________________________________
Your smile counts. The more smiles you share, the more we donate.  Join in.
www.windowslive.com/smile?ocid=TXT_TAGLM_Wave2_oprsmilewlhmtagline