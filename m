Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYHRW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYHRW1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYHRW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:27:11 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41151 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYHRW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:27:10 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <20080818225105.42784da0@lxorguk.ukuu.org.uk>
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
	 <20080818225105.42784da0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:27:04 -0500
Message-Id: <1219098424.3261.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 22:51 +0100, Alan Cox wrote:
> > > I completely agree that irq number 99.9% of the time should be a completely
> > > abstract token.
> > 
> > Sure, although one nice reason for doing the abstraction first is that
> > it stops people imposing fragile numbering schemes on irq ...
> 
> On a lot of embedded devices IRQ numbers are not abstract and not
> fragile. I'm all for abstracting out interrupts nicely but it isn't just
> the legacy PC cases to consider - a lot of embedded is at least as
> defined, rigid and meaningfully numbered as ISA.

So for these, the abstraction transformation is the identity ... meaning
they behave as they always have.

James


