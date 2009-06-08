Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZFHUUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZFHUUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZFHUUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:20:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43315 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752207AbZFHUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:20:01 -0400
Date: Mon, 8 Jun 2009 16:20:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jonathan Cervidae <jonathan.cervidae@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: Removing Huawei E220 HSDPA Modem causes system to
 completely hang
In-Reply-To: <alpine.LRH.2.00.0906081317070.31685@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0906081617300.13888-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Jiri Kosina wrote:

> [ added linux-usb to CC and kept the whole original mail for reference ]
> 
> On Mon, 8 Jun 2009, Jonathan Cervidae wrote:
> 
> > While at first the easy fix to this issue would be "Don't remove modem", 
> > sometimes it resets itself and therefore appears to disconnect and 
> > reconnect which causes the system crash.
> 
> What is the product ID of the device? (lsusb will tell you).
> 
> > I can reproduce the problem 80% of the time by ripping the modem out of 
> > the USB port. However, if I kill -9 pppd before doing it, it never 
> > happens so the problem appears to be an interaction between pppd and the 
> > kernel. As full system lockups in my limited knowledge must be kernel 
> > problems since systems should never fully lock (with flashing caps lock 
> > and scroll lock lights, not responsive to magic sysreq keys) presumably 
> > this is a kernel bug.
> > 
> > It also did not happen until recently, some point within the last month. I 
> > would have reported it earlier (and reverted to a kernel that didn't do it) 
> > but didn't realise why it was happening.

Two patches for usb-serial drivers were posted recently to fix this 
sort of problem:

	http://marc.info/?l=linux-usb&m=124395806322087&w=2
	http://marc.info/?l=linux-usb&m=124395806222085&w=2

See if the two of them together solve everything.

Alan Stern

