Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbXE1FZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbXE1FZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 01:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXE1FZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 01:25:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbXE1FZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 01:25:16 -0400
Message-ID: <465A6742.4090903@zytor.com>
Date: Sun, 27 May 2007 22:23:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       abraham.manu@gmail.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net> <ada3b1h3gke.fsf@cisco.com> <20070528041802.GB711@colo.lackof.org>
In-Reply-To: <20070528041802.GB711@colo.lackof.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sun, May 27, 2007 at 06:03:29PM -0700, Roland Dreier wrote:
> ...
>>  > I can imagine many systems where the cpu simply doesn't have enough
>>  > interrupt pins to uniquely identify every possible MSI interrupt
>>  > source.
>>
>> I have a hard time imagining a PCI host bus controller that converts
>> MSI interrupts back to wire interrupts that go to pins on the CPU.
>> For one thing it would be hard to maintain the guarantee that
>> MSI interrupts can't pass DMAs.
> 
> Whatever converts the MSI back to CPU IRQ pins would have to participate
> in the "cache coherency domain". This would avoid issues around DMA ordering.
> It _could_ be on the same silicon as the PCI Host bus controller as long
> as the above is true.
> 

Also, don't forget that a lot of platforms provide *no* hardware cache
coherency.

	-hpa
