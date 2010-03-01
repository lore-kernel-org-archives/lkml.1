Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0CATrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:47:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49322 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359Ab0CATru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:47:50 -0500
Date: Mon, 1 Mar 2010 19:50:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: David Brownell <david-b@pacbell.net>,
       Denis Turischev <denis@compulab.co.il>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
Message-ID: <20100301195059.150a9972@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003011304500.4281@localhost.localdomain>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B7C0DC3.3060907@compulab.co.il>
	<4B812C21.8000602@compulab.co.il>
	<201002211112.48527.david-b@pacbell.net>
	<4B84CC0E.5060203@compulab.co.il>
	<alpine.LFD.2.00.1003011304500.4281@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Mar 2010 13:09:22 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> > I've looked at two x86 drivers in drivers/gpiolib (cs5535 and langwell) and
> > there's no treatment of ACPI in either of them. Since SCH is defined by Intel
> > as "embedded" product, having a GPIO driver for it seems logical even despite
> > problems you mention.
> 
> FWIW
> I believe that Langwell is used only in products without an ACPI BIOS.
> 
> Poulsbo, OTOH, is used in zillions of netbooks running Windows XP.
> I don't know what a cs5535 is.

Cyrix (then NatSemi then AMD) Geode companion chip. May be present
without having ACPI although ACPI was added as a BIOS upgrade to the older
ones.

Alan
