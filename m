Return-Path: <linux-kernel-owner+w=401wt.eu-S1945895AbXDLHbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945895AbXDLHbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945913AbXDLHbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:31:20 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:15558 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945895AbXDLHbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lzg67Z7B29NSTRECfjU/QogGsR61M+2Eiw+Bkfi5UB8CPxG1Dw8t9NU0GRpRa6Z7MVuuceNW/vDFVAZxt2T+CYyFW8yT5P18rqAK2SV4rnptswrxQCJiebplnd4/CREyXRWZImLWKOu7IN63dnZLpPFgye/Z/CpLak4Keq6r1y0=
Message-ID: <54d79d810704120031x561af38dle108c6514ae89dc5@mail.gmail.com>
Date: Thu, 12 Apr 2007 13:01:18 +0530
From: "Rahul Hirve" <rahulhirve@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCI BAR register assignment error
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am using a customized PCI board of IXP2400 (Intel's network
processor) on host PC having xeon dual core processor with Redhat
2.6.9.

My PCI card is running RedBoot on it.

After booting I am not able to get BAR register on my IXP2400 card
assigned properly.

If I do lspci –vv on host following is the output I am getting for my card



 04:03.0 Co-processor: Intel Corp. IXP2400 Network Processor (rev 01)
(prog-if 01)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (250ns min, 1000ns max), Cache Line Size 10
	Interrupt: pin A routed to IRQ 209
	Region 0: Memory at <ignored> (32-bit, non-prefetchable)
	Region 1: Memory at <ignored> (32-bit, prefetchable)
	Region 2: Memory at <ignored> (32-bit, prefetchable)


But if I reboot my host machine after this then next time I am getting
BAR register assignment properly

And my lspci –vv output is as



04:03.0 Co-processor: Intel Corp. IXP2400 Network Processor (rev 01)
(prog-if 01)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (250ns min, 1000ns max), Cache Line Size 10
	Interrupt: pin A routed to IRQ 209
	Region 0: Memory at dee00000 (32-bit, non-prefetchable) [size=1M]
	Region 1: Memory at ddf00000 (32-bit, prefetchable) [size=1M]
	Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]



I am not getting why this behavior happens, any guess?

Thanks
Rahul
