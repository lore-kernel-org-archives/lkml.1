Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab0BYUzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:55:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:33907 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525Ab0BYUzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:55:20 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <Pine.LNX.4.44L0.1002241641370.1253-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002241641370.1253-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 07:52:58 +1100
Message-ID: <1267131178.23523.1729.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 16:50 -0500, Alan Stern wrote:
> The main issue here is that the same host controller will use PIO
> sometimes and DMA sometimes, depending on the details of the
> transfer.  
> The USB core didn't expect this and consequently we violated the rules
> for DMA mapping.  The question is: If the core is fixed so that the
> rules aren't violated, will everything work correctly? 

As long as the only issue is that one (ie, doing PIO while dma-map'ed),
then yes, I'd say things should work. If not, then there is -another-
problem to be fixed :-)

Cheers,
Ben.


