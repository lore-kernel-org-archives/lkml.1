Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXLDPKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXLDPKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXLDPKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:10:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:43102 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXLDPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JfMXj+K/bhNEjKpPKkfnUgv/qzcZRt0q6HrlpZ3riDf6eNsA6LrCS30Ckq/EUZtxtrKHCijMz8k+sgVo5jYUaEjZd4g4ZYfdZ9I/L00/Vhg7AWinV9h1tTGJUKO4aG5Q4qXnre3bWr+TDSuWIOHV7Gbk6M5XwgoI/GbkmV8TJQY=
Message-ID: <6101e8c40712040710w22fe220ewb85eccfeb1a55740@mail.gmail.com>
Date: Tue, 4 Dec 2007 16:10:40 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Pavol Cvengros" <pavol.cvengros@primeinteractive.net>
Subject: Re: ICH9 & Core2 Duo - kernel crash
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200712041331.24678.pavol.cvengros@primeinteractive.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712041331.24678.pavol.cvengros@primeinteractive.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/07, Pavol Cvengros <pavol.cvengros@primeinteractive.net> wrote:
> Hello,
>
> I am trying LKML to get some help on one linux kernel related problem.
> Lately we got a machine with new HW from Intel. CPU is Intel Core2 Duo E6850
> 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33 chipset.
>
> After long fight with kernel crashes on different things, we figured out
> that
> if the multicore is disabled in bios, everything is ok and machine is
> running
> good. No kernel crashes no problems, but with one core only.
>
> This small table will maybe explain:
>
> Cores   -     kernel   -   state
>    2  -   nonsmp or smp  - crash
>    1  -  smp or nonsmp  - ok
>
> All crashes have been different (swaper, rcu, irq, init.....) or we just got
> internal gcc compiler error while compiling kernel/glibc/.... and the
> machine
> was frozen.
>
> Please can somebody advise what to do to identify that problem more
> precisely.
> (debug kernel options?)
>
> Our immpresion - ICH9 & ICH9R support in kernel is bad... sorry to say..
>
> lspci:
> 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics
> Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
> 00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation PCI Express Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation PCI Express Port 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation PCI Express Port 4 (rev 02)
> 00:1c.4 PCI bridge: Intel Corporation PCI Express Port 5 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 4 port SATA IDE Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
> 00:1f.5 IDE interface: Intel Corporation 2 port SATA IDE Controller (rev 02)
> 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port
> PATA133 interface (rev b1)
> 06:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
>
> Thanks for any kind of help...

kernel version?

>
> Best regards,
>
> Pavol Cvengros
>
> --
> -----------[ Signature ]---------
> Name: Pavol Cvengros
> Company: Prime Interactive, Ltd.
> E-mail: pavol.cvengros@primeinteractive.net
> Web: http://www.primeinteractive.net
> Personal web: http://orpheus.grass.sk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
