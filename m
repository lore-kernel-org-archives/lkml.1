Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXJGBXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXJGBXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 21:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXJGBXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 21:23:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:53539 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXJGBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 21:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=XTHOglXrv0VmMO7I9bv7giGIGIQ/F6QWhR7APg6FxzB6nH80nfb3xT/+ONXVO9Hnk/uLU6hc4L8u1XRHRuLudY7Hy+4femq4KDVVh2XYnJzJnFQ0u0fT712J7mGz4K7hiXsMsE1fLQfnMBQH4npq9IY2w0gaBr7czgeIP3Tb96Q=
Message-ID: <47083555.2060605@gmail.com>
Date: Sat, 06 Oct 2007 22:24:37 -0300
From: Hernan G Solari <hgsolari@gmail.com>
Reply-To: hgsolari@gmail.com
Organization: Universidad de Buenos Aires
User-Agent: Icedove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com> <47014740.5080002@df.uba.ar> <4701EA71.2000609@gmail.com> <470220FE.2090506@gmail.com> <47044C6C.5030905@gmail.com>
In-Reply-To: <47044C6C.5030905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If you can set up a serial console, it would be better.  If not, can you
> please take a photo of the crash and post it?
>   
I am running short of elements, no digital camera o movil phone for the 
case or serial link.
However, what it is on the screen when it crashes follows:

KERNEL 2.6.23-rc8
-----------------------------------------------------begin screen dump
PCI: Bridge: 0000:00:14.4
  IO window: a000-afff
  MEM window: d0300000-d03fffff
  PREFETCH window: 50000000-53ffffff
PCI: Enabling device 0000:00:04.0 (0000 -> 0002)
PCI: Enabling device 0000:08:01.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:08:01.0[A] -> GSI 23 (level, low) -> IRQ 23
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
-------------------------------end screen dump

Not so difficult since most of these lines are also in a succesful boot 
with some of the ACPI turned off.

Hernan

-- 
Hernán Gustavo Solari, solari@df.uba.ar, http://www.df.uba.ar/~solari

