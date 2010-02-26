Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966324Ab0BZVuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:50:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46774 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966303Ab0BZVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:49:59 -0500
Date: Fri, 26 Feb 2010 21:49:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100226214908.GD23933@n2100.arm.linux.org.uk>
References: <1266979632.23523.1668.camel@pasglop> <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com> <1267220429.23523.1811.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267220429.23523.1811.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 08:40:29AM +1100, Benjamin Herrenschmidt wrote:
> Hrm, the DMA API certainly doesn't handle the I$/D$ coherency on
> powerpc.. I'm afraid that whole cache handling stuff is totally
> inconsistent since different archs have different expectations here.

It doesn't on ARM either.
