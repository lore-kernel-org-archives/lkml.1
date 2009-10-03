Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZJCV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZJCV12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 17:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZJCV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 17:27:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43801 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757128AbZJCV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 17:27:27 -0400
Date: Sat, 3 Oct 2009 17:26:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
In-Reply-To: <94a0d4530910030335p2eae17a6wddf6d87b7f60b712@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0910031720590.18843-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009, Felipe Contreras wrote:

> Hi,
> 
> This is with 2.6.31.1.
> 
> I'm having a lot of problems with a lacie external hd[1]. It seems the
> actual disk is a seagate ST375064, and the bridge is a JMicron 2339.
> 
> In normal usage what I see is that if I don't use the disk after a
> while hear a loud click (as if something got stuck) and then I cannot
> use it any more; I have to turn it off and on again.

This sounds very much like a hardware problem, either in the drive or
in the bridge chip.  There's no direct way to tell which; you would
have to try attaching the drive to a different chip or the chip to a
different drive.

The two places where your listings showed the Serial number (the kernel
log and the /sys/kernel/debug/usb/devices file) have different values,
suggesting that the chip is at fault.  But this isn't definitive.

Alan Stern


