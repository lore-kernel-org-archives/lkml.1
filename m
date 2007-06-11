Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbXFKLO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbXFKLO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbXFKLOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:14:52 -0400
Received: from relay00.pair.com ([209.68.5.9]:1841 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751163AbXFKLOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:14:51 -0400
X-pair-Authenticated: 81.78.108.18
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ralph Corderoy <ralph@inputplus.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: How to get an IDE Hard Reset, not a Soft Reset? 
In-reply-to: <200706091540.19661.linux@rainbow-software.org> 
References: <20070609131031.CBB5014A521@blake.inputplus.co.uk> <200706091540.19661.linux@rainbow-software.org>
Comments: In-reply-to Ondrej Zary <linux@rainbow-software.org>
   message dated "Sat, 09 Jun 2007 15:40:19 +0200."
Date: Mon, 11 Jun 2007 11:54:11 +0100
From: Ralph Corderoy <ralph@inputplus.co.uk>
Message-Id: <20070611105411.80E0B14A20C@blake.inputplus.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ondrej,

Ondrej Zary wrote:
> Ralph Corderoy wrote:
> > As I understand it, an IDE hard drive can be reset in three ways.  A
> > power-on reset, a hard reset caused by pin 1 (RESET-) on the IDE
> > connector, and a soft reset (bit SRST in the device control
> > register).  RESET- is held low on a power on, but can also be used
> > later to do a hard reset.
> 
> The RESET pin is often wired to the system RESET signal, so there is
> no way to control it separately.

Yes, I think you're correct.  I found a south bridge spec.,
http://www.tser.org/vt8231/vt8231.pdf, and I don't see a pin for driving
an IDE RESET-.

Oh well, I suppose I either dike out RESET- from the IDE cable and wire
it up to a serial or parallel port, or give up using a PC for the task
and use a dedicated circuit.

Thanks for your help.


Ralph.

