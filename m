Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbXIROZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbXIROZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXIROZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:25:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46561 "EHLO
	caffeine.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbXIROZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:25:43 -0400
Date: Tue, 18 Sep 2007 10:25:42 -0400
To: Duncan.Perrett@elekta.com
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI Interrupt
Message-ID: <20070918142542.GG5386@csclub.uwaterloo.ca>
References: <Pine.LNX.4.61.0709180955360.6632@chaos.analogic.com> <OF8D17B2FD.EFB025F4-ON8025735A.004DB087-8025735A.004DB743@elekta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF8D17B2FD.EFB025F4-ON8025735A.004DB087-8025735A.004DB743@elekta.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:08:46PM +0100, Duncan.Perrett@elekta.com wrote:
> The driver already does that ...
> 
> result =
>         request_irq(irq, can_pci_interrupt, SA_INTERRUPT | SA_SHIRQ,
>                     pDevice->au8IrqName, pDevice);
> 
> 
> Any other ideas?

Maybe the system thinks a ps2 mouse port owns irq 12 and messes it up as
a result.

--
Len Sorensen
