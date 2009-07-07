Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZGGBuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZGGBuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZGGBuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:50:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33518 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752994AbZGGBuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:50:06 -0400
Date: Mon, 6 Jul 2009 21:50:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Zbigniew Luszpinski <zbiggy@o2.pl>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Nvidia OHCI chipset MCP78S (Geforce 8200) hangs on >
 1Mbit transfers if noapic/acpi=noirq is missing
In-Reply-To: <200907062340.56308.zbiggy@o2.pl>
Message-ID: <Pine.LNX.4.44L0.0907062147200.21717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Zbigniew Luszpinski wrote:

> I hope I find here someone who wrote or know Linux ohci driver so he/she knows 
> how to slow down ohci bulk/iso IO operations without breaking hotplug.

The speed of iso operations cannot be changed, because the transactions 
have to occur at a specified interval.

OHCI doesn't provide any way to slow down bulk operations either, once 
a bulk URB has been submitted.  The best you can do is slow down the 
rate of submission.  But you already tried that and it didn't work.

> It looks Linux ohci driver is more aggressive on ohci IO than windows one so 
> making Linux less timing demanding would help my MCP78S keep working.

I suspect you're looking in the wrong direction.  There's probably 
something wrong at a deeper level, in the chipset drivers for instance.

Alan Stern

