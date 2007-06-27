Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbXF0Ay6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbXF0Ay6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXF0Ayv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:54:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXF0Ayu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:54:50 -0400
Date: Tue, 26 Jun 2007 17:54:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IkouQS4gTWFnYWxs824i?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Problems with fb console [was Re: 2.6.12-rc4-mm2]
Message-Id: <20070626175433.dceee930.akpm@linux-foundation.org>
In-Reply-To: <20070627023527.5e643e32@werewolf-wl>
References: <20050516021302.13bd285a.akpm@osdl.org>
	<20070627023527.5e643e32@werewolf-wl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 02:35:27 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 16 May 2005 02:13:02 -0700, Andrew Morton <akpm@osdl.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.12-rc4/2.6.12-rc4-mm2/
> > 
> > 
> 
> Hi...
> 
> I have a (stupid, I suppose) problem with framebuffer console.
> I have builtin VESAFB in this kernel, so:
> 
> werewolf:/boot# grep _FB config-2.6.21-jam09 | grep =y
> CONFIG_FB=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_VESA=y
> werewolf:/boot# grep CONSO config-2.6.21-jam09
> # CONFIG_NETCONSOLE is not set
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_VGA_CONSOLE=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> 
> I put this line in grub's menu.lst:
> 
> kernel /boot/vmlinuz video=vesafb:mtrr,ywrap vga=0x31A ro root=/dev/sdc1
> 
> (tried both with hex and decimal).
> 
> but grub keeps telling me it can't set that video mode, and I have no
> /dev/fb0 device to try with fbset. I have a '29 fb' line in /proc/devices.
> 
> Any ideas about why the device is missing ? udev is 113...
> I have followed al the info I could get (linux/Documentation/fb/, Google ;) )
> and all say that what I'm doing should work. What am I doing wrong ?
> 

Methinks that'll be git-newsetup changes?
