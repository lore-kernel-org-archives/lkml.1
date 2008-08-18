Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYHRWJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYHRWJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYHRWJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:09:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44851 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753275AbYHRWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:09:01 -0400
Date: Mon, 18 Aug 2008 22:51:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Message-ID: <20080818225105.42784da0@lxorguk.ukuu.org.uk>
In-Reply-To: <1219097061.3261.76.camel@localhost.localdomain>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	<86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	<1218898238.3940.6.camel@localhost.localdomain>
	<20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	<1218903209.3940.14.camel@localhost.localdomain>
	<86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
	<1218918341.3940.49.camel@localhost.localdomain>
	<86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
	<1218919547.3940.57.camel@localhost.localdomain>
	<86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>
	<1218928162.3940.62.camel@localhost.localdomain>
	<m14p5i2iwx.fsf@frodo.ebiederm.org>
	<1219093158.3261.70.camel@localhost.localdomain>
	<m17iaexai3.fsf@frodo.ebiederm.org>
	<1219097061.3261.76.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I completely agree that irq number 99.9% of the time should be a completely
> > abstract token.
> 
> Sure, although one nice reason for doing the abstraction first is that
> it stops people imposing fragile numbering schemes on irq ...

On a lot of embedded devices IRQ numbers are not abstract and not
fragile. I'm all for abstracting out interrupts nicely but it isn't just
the legacy PC cases to consider - a lot of embedded is at least as
defined, rigid and meaningfully numbered as ISA.

Alan
