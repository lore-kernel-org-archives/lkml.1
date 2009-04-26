Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZDZM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZDZM0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZDZM0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:26:06 -0400
Received: from main.gmane.org ([80.91.229.2]:51230 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZDZM0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:26:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jeffrey Cao <jcao.linux@gmail.com>
Subject: Re: Kernel locks up when idle on VIA-nano U2300 with VIA VX800 on
 Jetway JNF76-N1GL-LF mainboard
Date: Sun, 26 Apr 2009 12:25:51 +0000 (UTC)
Message-ID: <gt1jsf$hb8$1@ger.gmane.org>
References: <20090426095121.GS26701@catull.sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 219.134.168.15
User-Agent: slrn/pre1.0.0-2 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-04-26, Martin Mueller <mm@sig21.net> wrote:
> Hi all,
>
> last Thursday my mini-ITX board in my home-server died and I had to
> get a replacement board. I got an fanless Jetway JNF76-N1GL-LF from a
> local Dealer. The board uses a 1GHz U2300 VIA-nano CPU[1] and an VIA
> VX800 chipset. After replacing the board, the adventure actually
> started:
>
> Booting my installed debian with kernel 2.6.29-1-686 (debian kernel) failed.
> The system just hang when detecting the harddisks during the boot
> process, no oops, no messages, just no reaction any more. 
>
> Fortunatelly I had an old 2.6.23-1-686 (debian kernel) still hanging around
> in the grub menu. This kernel works flawlessly on the board (aside
> from not recognizing the VIA HD-audio, which doesn't bother me at the
> moment).
>
> Next, I downloaded linux-2.6.30-rc3, compiled a minimal version with
> just initrd. I left out PCI-support, ACPI and almost everything else
> menuconfig allowed me to unselect except the VGA text console. This
> kernel locked up after giving me the initial prompt from busybox in
> the initrd.
>
> When adding the following lines in the script executed by the kernel
> after booting in the initrd, the system actually works:
>
>   while true; do true; done &
>   /bin/sh
>
> As soon as I kill the shell loop, the system freezes again.
>
> So my conclusion is: the kernel locks up the first time the CPU
> is idle.
>
> Any hints on how to proceed from here?
>

This seems something to do with the board and the hard disk drive.
Do you attach the hard disk to the board correctly? Is there any jumper settings
on the board? Is there any additional module needed by your new board? You can
boot a live CD (Ubuntu is a nice one, it is built with most latest kernel and 
modules) and try to mount your hard disk to make sure the hardware is OK. If this
works, then try to figure out which module is missing in your old kernel.

Jeffrey

