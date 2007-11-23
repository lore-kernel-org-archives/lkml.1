Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbXKWPw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbXKWPw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 10:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXKWPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 10:52:51 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:37838 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbXKWPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 10:52:50 -0500
Message-ID: <4746F747.4010906@systella.fr>
Date: Fri, 23 Nov 2007 16:52:39 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.9) Gecko/20071030 Iceape/1.1.6 (Debian-1.1.6-2)
MIME-Version: 1.0
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG (3Com 3c905 adapter)
References: <4746C44B.8040008@systella.fr>
In-Reply-To: <4746C44B.8040008@systella.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Fri, 23 Nov 2007 16:52:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BERTRAND Joël wrote:
>     Hello,
> 
>     Since I have installed a 2.6.23.1 linux kernel on my U60, I can see 
> several NETDEV WATCHDOG. This trouble never occurs with 2.6.23-rc4.
> This bug occurs after a random uptime.

	I have made the same constation this evening on a amd64/up with two 
3C905 and a 2.6.21.3 linux kernel... This evening, I have rebooted my 
U60 with a 2.6.23.8 kernel and the same 3C905 runs fine. Wait and see 
(but I suspect a kernel bug...).

	For main linux kernel list:

> End of dmesg :
> 
> NETDEV WATCHDOG: eth2: transmit timed out
> eth2: transmit timed out, tx_status 00 status 8601.
>   diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
> eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
>   Flags; bus-master 1, dirty 144(0) current 144(0)
>   Transmit list 00000000 vs. fffff800a06b0200.
>   0: @fffff800a06b0200  length 8000004a status 0001004a
>   1: @fffff800a06b0260  length 80000062 status 00010062
>   2: @fffff800a06b02c0  length 80000062 status 00010062
>   3: @fffff800a06b0320  length 80000062 status 00010062
>   4: @fffff800a06b0380  length 80000062 status 00010062
>   5: @fffff800a06b03e0  length 80000062 status 00010062
>   6: @fffff800a06b0440  length 80000062 status 00010062
>   7: @fffff800a06b04a0  length 80000062 status 00010062
>   8: @fffff800a06b0500  length 80000062 status 00010062
>   9: @fffff800a06b0560  length 80000062 status 00010062
>   10: @fffff800a06b05c0  length 80000062 status 00010062
>   11: @fffff800a06b0620  length 80000062 status 00010062
>   12: @fffff800a06b0680  length 80000062 status 00010062
>   13: @fffff800a06b06e0  length 8000004a status 0001004a
>   14: @fffff800a06b0740  length 80000062 status 80010062
>   15: @fffff800a06b07a0  length 80000062 status 80010062
> eth2: Resetting the Tx ring pointer.
> eth2:  setting full-duplex.
> 
> Root rayleigh:[/proc] > cat interrupts
>            CPU0       CPU2
>   0:  318071624  318071584     <NULL>  timer
>   1:          0          0      sun4u  PSYCHO_PCIERR
>   2:          0          0      sun4u  PSYCHO_UE
>   3:          0          0      sun4u  PSYCHO_CE
>   8:     559916          0      sun4u  su(kbd)
>   9:          0    4170845      sun4u  su(mouse)
>  10:          0          0      sun4u  parport0
>  11:          2          0      sun4u  floppy
>  12:          0          0      sun4u  cs4231(capture)
>  13:     789858          0      sun4u  cs4231(play)
>  14:       1329   17123911      sun4u  eth0
>  15:          0   15905664      sun4u  sym53c8xx
>  16:         30          0      sun4u  sym53c8xx
>  17:     364465     223693      sun4u  eth2
>  18:   11043701          0      sun4u  aic7xxx
>  19:          1      50585      sun4u  ohci_hcd:usb2
>  20:          0          0      sun4u  ohci_hcd:usb3
>  21:          1          1      sun4u  ehci_hcd:usb1
>  22:          0          0      sun4u  PSYCHO_PCIERR
>  24:   17346674        332      sun4u  eth1
> Root rayleigh:[/proc] > lspci
> 0000:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus 
> Module
> 0000:00:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
> 0000:00:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy 
> Meal (rev 01)
> 0000:00:02.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M 
> [Tornado] (rev 78)
> 0000:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 
> (rev 14)
> 0000:00:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 
> (rev 14)
> 0000:00:04.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
> 0000:00:05.0 USB Controller: NEC Corporation USB (rev 43)
> 0000:00:05.1 USB Controller: NEC Corporation USB (rev 43)
> 0000:00:05.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
> 0001:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus 
> Module
> 0001:80:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
> 0001:80:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy 
> Meal (rev 01)
> Root rayleigh:[/proc] > cat irq/17/smp_affinity
> f
> Root rayleigh:[/proc/net] > cat dev
> Inter-|   Receive                                                |  
> Transmit
>  face |bytes    packets errs drop fifo frame compressed multicast|bytes 
>    packets errs drop fifo colls carrier compressed
>   eth1:9421385785 9787261    0    0    0     0          0         0 
> 2418854910 7465439    0    0    0     0       0          0
>   eth0:3977175515 8320824    0    0    0     0          0         0 
> 8252404266 9204851    0    0    0     0       0          0
>   eth2:47410723  344515    0    0   51     0          0         0 
> 31875309  278022  872    0    0     0       0          0
>     lo:240810303 1749211    0    0    0     0          0         0 
> 240810303 1749211    0    0    0     0       0          0
> 
>     Regards,
> 
>     JKB
