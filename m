Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXE0Cen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXE0Cen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXE0Ceg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:34:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXE0Cef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:34:35 -0400
Message-ID: <4658EE32.5080506@zytor.com>
Date: Sat, 26 May 2007 19:34:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: abraham.manu@gmail.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <46561287.8020103@gmail.com>	<ada1wh560u1.fsf@cisco.com>	<46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net>
In-Reply-To: <20070526.154910.78725926.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> 
>> i presume then i shouldn't be using IRQF_SHARED, if using MSI.
> 
> That's actually a really good question.
> 
> It is likely architecture dependant whether the PCI controller wires
> unique MSI interrupts to shared cpu interrupt lines.
> 
> I can imagine many systems where the cpu simply doesn't have enough
> interrupt pins to uniquely identify every possible MSI interrupt
> source.

There are systems which only get a single bit indication that an MSI has
happened.

Presumably we need something like IRQF_MSI which can be set as
appropriate depending on the architecture?

	-hpa
