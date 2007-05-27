Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbXE0BBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbXE0BBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 21:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXE0BBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 21:01:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXE0BBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 21:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LwjAscbUP9bCMH51SgLWEnQ3nflsq8wk2u2UHhy4wqo9qnf6+oCsfB/FlMJ6eggCbc5UE6ccfGl2/F9s6HoUysYOTJQBhgOQvxw8k3lG/QjXdf2lNTQbhmCmy5thmmaFTCdlTqQI9aj5E0qCv751nnsyc880yzxOrzZnMy2XjXc=
Message-ID: <4658D84E.6050807@gmail.com>
Date: Sun, 27 May 2007 05:01:02 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grundler@parisc-linux.org, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <20070526235515.GA31023@colo.lackof.org>	<20070526.170039.119261389.davem@davemloft.net>	<20070527001631.GC31023@colo.lackof.org> <20070526.173037.45196275.davem@davemloft.net>
In-Reply-To: <20070526.173037.45196275.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Grant Grundler <grundler@parisc-linux.org>
> Date: Sat, 26 May 2007 18:16:31 -0600
> 
>> Are they really? The device is generating the transaction on the bus.
>> The PCI host controller (in general) will be routing that transaction
>> to wherever the "dest addr" of the MSI lives. It doesn't have to be
>> in the CPU but it will certainly be a proxy for that CPU if it's not.
>> We won't care if the proxy only have one IRQ line going to the CPU
>> as long as the de-muxing of the "data" portion results in a unique
>> identifier that can be mapped to exactly one interrupt handler.
> 
> True, on sparc64 PCI-E controllers, for example, the MSI vector is
> received by the PCI-E host controller, and the host controller turns
> this into a cpu format interrupt packet for the system bus.

Err .. why would a PCIe controller be CPU specific ? Looking at Figure
1-6 of the spec, i think it should be CPU independent ?

Excuse me for my ignorance, just that my head has begun to reel after
reading through PCIe 1.0 and the device specs, still being inconclusive
how to proceed.

