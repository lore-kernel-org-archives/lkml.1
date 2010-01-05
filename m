Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820Ab0AERoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0AERoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706Ab0AERoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:44:14 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:48839 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0AERoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:44:14 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:44:13 EST
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Brooks <a.brooks@marathon-robotics.com>, linux-pci@vger.kernel.org
Subject: Re: BAR 0: can't allocate resource
Date: Tue, 5 Jan 2010 10:33:18 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201001052018.02607.a.brooks@marathon-robotics.com>
In-Reply-To: <201001052018.02607.a.brooks@marathon-robotics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051033.19486.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added linux-pci because this appears PCI-related.

On Tuesday 05 January 2010 02:18:02 am Alex Brooks wrote:
> I have a problem getting a couple of PCI cards to play nicely together. ...

> And (for both kernels) the output of lspci has the following line:
>   01:04.0 Unclassified device [0080]: Device 0002:0080

When you have only the 8-port serial card installed, it appears at
01:04.0.  When you have both cards installed, we don't see a new device,
and whatever is at 01:04.0 no longer looks like the octal UART.

> Hardware Details:
>  - My motherboard is a DigitalLogic MSM945.  It has a PC104 bus.
>  - I have two PC104 cards:
>    i)  8-port serial card (DiamondSystems Emerald-MM-8Plus)
>    ii) PC/104+ to MiniPCI Adapter (ConnectTech) (no MiniPCI cards installed).

Do you have these two cards?

  http://www.diamondsystems.com/products/emeraldmm8plus,
  http://www.connecttech.com/sub/Products/PC104plus_MiniPCI.asp

If so, both of those web pages mention jumpers that set the card's
PCI device ("slot") number.  My guess is that both of your cards
are set to the same number.

Bjorn
