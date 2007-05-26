Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbXEZWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbXEZWtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXEZWtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:49:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51407
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbXEZWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:49:05 -0400
Date: Sat, 26 May 2007 15:49:10 -0700 (PDT)
Message-Id: <20070526.154910.78725926.davem@davemloft.net>
To: abraham.manu@gmail.com
Cc: rdreier@cisco.com, greg@kroah.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: PCIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <46584C30.4030206@gmail.com>
References: <46561287.8020103@gmail.com>
	<ada1wh560u1.fsf@cisco.com>
	<46584C30.4030206@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manu Abraham <abraham.manu@gmail.com>
Date: Sat, 26 May 2007 19:03:12 +0400

> i presume then i shouldn't be using IRQF_SHARED, if using MSI.

That's actually a really good question.

It is likely architecture dependant whether the PCI controller wires
unique MSI interrupts to shared cpu interrupt lines.

I can imagine many systems where the cpu simply doesn't have enough
interrupt pins to uniquely identify every possible MSI interrupt
source.
