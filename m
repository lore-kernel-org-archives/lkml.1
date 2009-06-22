Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZFVNXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZFVNXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFVNWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:22:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33073 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753021AbZFVNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:22:52 -0400
Date: Mon, 22 Jun 2009 14:24:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Marc Zyngier <maz@misterjones.org>, Vikram Pandita <vikram.pandita@ti.com>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] serial: 8250: add IRQ trigger support
Message-ID: <20090622142402.5e36e7fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622124037.GD7352@atomide.com>
References: <1244827971-14981-1-git-send-email-vikram.pandita@ti.com>
	<20090612213127.0f03e0c5@taxman.wild-wind.fr.eu.org>
	<20090622124037.GD7352@atomide.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To me it sounds like the it would be better to have unsigned
> long irqflags in struct uart_port instead of trying to squeeze
> the irqflags the flags field. We're already not covering all the
> irqflags currently like Marc pointed out.

Agreed.

Alan
