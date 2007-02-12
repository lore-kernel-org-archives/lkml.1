Return-Path: <linux-kernel-owner+w=401wt.eu-S965413AbXBLVLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413AbXBLVLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXBLVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:11:07 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:34577 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S965414AbXBLVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:11:06 -0500
Date: Mon, 12 Feb 2007 12:56:21 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Andy Kennedy <akennedy@techmoninc.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Serial console issues.
In-Reply-To: <45D0D09D.8010807@techmoninc.com>
Message-ID: <Pine.LNX.4.63.0702121255100.6630@qynat.qvtvafvgr.pbz>
References: <45D0D09D.8010807@techmoninc.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Andy Kennedy wrote:

> 
> For those of you who are on BusyBox's mailing list, you've already seen this 
> -- I was sent here for help.
>
> Specs:
> Linux:  2.6.18
> Bootloader:  SysLinux
> Init:  BusyBox (ver 1.4.0) init.
> Kernel command line: console=ttyS0,115200,n,8,1
> System: VersaLogic 568 (STD80/STD32 Bus, i386 based computer)
> Issue:  Booting on "System" I get perfect printk's to the serial console. 
> When the init takes over (from within an initrd), the console begins to miss 
> characters.  I can still send write commands through the console, however, 
> the output of these commands is garbled.  The really odd part is when the 
> init releases control (is killed by Linux), or when a printk is issued, the 
> console prints perfectly again.  The next really strange part about this is 
> that changing "System" to my laptop -- no problems PERIOD. 
> The BusyBox list directed me to LKML as this is a wider base of users that 
> may have experienced the same problem and could provide me an answer.

I've seen this happen when you accidently have multple programs attached to the 
same console (even with the text-mode vga consoles)

double check that nothing else is trying to use that serial port

David Lang
