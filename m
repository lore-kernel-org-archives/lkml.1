Return-Path: <linux-kernel-owner+w=401wt.eu-S1759853AbXE0U3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbXE0U3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbXE0U3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:29:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:61683 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759609AbXE0U3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cviueRbbP5oy6tGSUxsECCeBQNyD2aoF+EetWvv0t3Z4n+Y7LGAnghF+E9cbvsMxKktUQN/zmey6wm5d0rHbRdijdgi8kB0QZhQXtx9dDIFAahkAwT9GQ56djbLxifyKMmTRvOH6zWJ9xnK0+Qkj49S5yv5GjNCQE4ZacVMaC+4=
Message-ID: <4659EA05.6070402@gmail.com>
Date: Mon, 28 May 2007 00:28:53 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <20070526235515.GA31023@colo.lackof.org> <20070526.170039.119261389.davem@davemloft.net> <20070527001631.GC31023@colo.lackof.org> <20070526.173037.45196275.davem@davemloft.net> <4658D84E.6050807@gmail.com> <20070527014945.GE31023@colo.lackof.org>
In-Reply-To: <20070527014945.GE31023@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sun, May 27, 2007 at 05:01:02AM +0400, Manu Abraham wrote:
>> David Miller wrote:
>>> True, on sparc64 PCI-E controllers, for example, the MSI vector is
>>> received by the PCI-E host controller, and the host controller turns
>>> this into a cpu format interrupt packet for the system bus.
>> Err .. why would a PCIe controller be CPU specific ? Looking at Figure
>> 1-6 of the spec, i think it should be CPU independent ?
> 
> To be pedantic, the PCIe controller isn't really CPU specific.
> It's host bus specific. ie the PCI-e controller is a bridge between
> whatever chipset defines the "cache coherency domain" and the PCI-e devices.
> 
>> Excuse me for my ignorance, just that my head has begun to reel after
>> reading through PCIe 1.0 and the device specs, still being inconclusive
>> how to proceed.
> 
> no problem...I suspect you need to figure out why DTL-MMIO isn't working.
> I have never touched DTL and can't be of much help with that.
> 

Have been reading a bit about DTL and so on. Haven't reached anything
much solid yet. Will have something soon i presume.

Thanks for the comments.

Regards,
Manu
