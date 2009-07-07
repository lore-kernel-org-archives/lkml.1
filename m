Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZGGPae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZGGPae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZGGPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:30:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60198 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755512AbZGGPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:30:19 -0400
Date: Tue, 7 Jul 2009 11:30:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>
Subject: Re: 2.6.31-rc2 warning in drivers/usb/host/ehci-hcd.c
In-Reply-To: <20090706222651.GA6709@Pilar.aei.mpg.de>
Message-ID: <Pine.LNX.4.44L0.0907071126350.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Carlos R. Mafra wrote:

> I was looking at the 'dmesg' output for 2.6.31-rc2 and noticed
> this warning
> 
> ------------[ cut here ]------------
> WARNING: at drivers/usb/host/ehci-hcd.c:1048 ehci_endpoint_reset+0xfc/0x140 [ehci_hcd]()
> Hardware name: VGN-FZ240E
> clear_halt for a busy endpoint

My earlier message was wrong; the code in the option driver isn't 
really wrong.

What were you doing when this occurred?  Can you get this to happen
again?  Can you collect a usbmon trace for when this happens?

Alan Stern

