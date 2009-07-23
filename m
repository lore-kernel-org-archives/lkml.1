Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZGWKdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZGWKdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZGWKdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:33:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35904 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751079AbZGWKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:33:03 -0400
Date: Thu, 23 Jul 2009 11:33:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vikram Pandita <vikram.pandita@ti.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: Boot Hang - mmotm 090716 - serial 8250 irq flags support
Message-ID: <20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
In-Reply-To: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
References: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 15:45:48 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> The mmotm dated 17jul09 atop 2.6.31-rc3 hangs [or appears to--could have
> just lost remote access via virtual serial port] during boot on HP
> Proliant DL585 [and perhaps others].  Checking back, the last mmotm to
> boot successfully on this platform was the 25jun09 snapshot.

Is your virtual serial port the console ? Also when you say "lost remote
access", at what point do you lose remote access - what is the last thing
printed to the console. What if anything is logged on the monitor if one
is plugged in and does it boot fine with the patch but without console
on the serial port ?

Is the virtual serial port a standard PC serial port (or appearing as
one) and using the standard drivers or is there anything else
loaded/special modules in use for it ?

> The offending patch appears to be commit
> 0b8d7a6fbba81ffd06de701fa6178916ee9732c3 - "serial-add-irqflags-support"
> in the linux-next mega-patch.  Reverting the changes to the 8250 driver
> allows the kernel to boot and operate normally.

Strange as it simply moves a few flags around. That ought to make it easy
to figure however.

