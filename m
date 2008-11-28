Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYK1M7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYK1M7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYK1M65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:58:57 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:46430 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYK1M6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EuC8GM7qXpJwIC3jO9zRQJTkx2J9qr41iiAF/6RN6/XuyVihgXsPDwB4pPvL/dxeje
         QkWsAlquh/4OvfsXPgYdq7mSE5YqXyiVc+CSbOguubABdITgImEpIbPXJT8esCrM6VSl
         nlvsMFTtRwVJ//cbnK21qUnf/GiTELvcitb40=
Message-ID: <a4423d670811280458r6e905433xa31d8d67741d8406@mail.gmail.com>
Date: Fri, 28 Nov 2008 15:58:54 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: next-20081126: x86_64: kernel BUG at kernel/params.c:637
In-Reply-To: <a4423d670811260830w19a67faak38b09f6153579af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811260830w19a67faak38b09f6153579af3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Alexander Beregalov <a.beregalov@gmail.com>:
> Brought up 4 CPUs
> Total of 4 processors activated (23949.39 BogoMIPS).
> khelper used greatest stack depth: 5712 bytes left
> net_namespace: 752 bytes
> NET: Registered protocol family 16
> ACPI FADT declares the system doesn't support PCIe ASPM, so disab
>
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> PCI: MCFG area at e0000000 reserved in E820
> PCI: Using MMCONFIG at e0000000 - efffffff
> PCI: Using configuration type 1 for base access
> PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
> ------------[ cut here ]------------
> kernel BUG at kernel/params.c:637!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.28-rc6-next-20081126 #24
> RIP: 0010:[<ffffffff806d7b25>]  [<ffffffff806d7b25>] param_sysfs_init+0x86/0xf3

Works again on next-20081128
