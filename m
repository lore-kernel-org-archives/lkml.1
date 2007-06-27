Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbXF0Afy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbXF0Afy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXF0Afp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:35:45 -0400
Received: from smtp.ono.com ([62.42.230.12]:35725 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752894AbXF0Afo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:35:44 -0400
Date: Wed, 27 Jun 2007 02:35:27 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Problems with fb console [was Re: 2.6.12-rc4-mm2]
Message-ID: <20070627023527.5e643e32@werewolf-wl>
In-Reply-To: <20050516021302.13bd285a.akpm@osdl.org>
References: <20050516021302.13bd285a.akpm@osdl.org>
X-Mailer: Claws Mail 2.9.2cvs70 (GTK+ 2.11.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2005 02:13:02 -0700, Andrew Morton <akpm@osdl.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.12-rc4/2.6.12-rc4-mm2/
> 
> 

Hi...

I have a (stupid, I suppose) problem with framebuffer console.
I have builtin VESAFB in this kernel, so:

werewolf:/boot# grep _FB config-2.6.21-jam09 | grep =y
CONFIG_FB=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_VESA=y
werewolf:/boot# grep CONSO config-2.6.21-jam09
# CONFIG_NETCONSOLE is not set
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set

I put this line in grub's menu.lst:

kernel /boot/vmlinuz video=vesafb:mtrr,ywrap vga=0x31A ro root=/dev/sdc1

(tried both with hex and decimal).

but grub keeps telling me it can't set that video mode, and I have no
/dev/fb0 device to try with fbset. I have a '29 fb' line in /proc/devices.

Any ideas about why the device is missing ? udev is 113...
I have followed al the info I could get (linux/Documentation/fb/, Google ;) )
and all say that what I'm doing should work. What am I doing wrong ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.21-jam09 (gcc 4.1.2 20070302 (4.1.2-1mdv2007.1)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
