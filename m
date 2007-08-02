Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbXHBVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbXHBVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXHBVL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:11:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32481 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbXHBVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aEqGPYIYuZr2YLmlXWr9Pqp6edFOsvrjn5t5Lz3mIF/2np1nZHBMCKoZhsoClh/TK8yl99tHkPZ7gAGPWj7zm/FAYkhhInhIsnmIsRydKjP6rrfJaS9x7/IxUUJo3Hqyqj8WcQxp+u4f1em4c2xYE4mRsULPbdGFUNLQ1vu1MAE=
Message-ID: <6278d2220708021411q17cdc151p79922e5dab74add4@mail.gmail.com>
Date: Thu, 2 Aug 2007 22:11:52 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: ICH8 CF timeout (regression)...
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46B20D6B.1060506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>
	 <46B20D6B.1060506@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Tejun Heo <htejun@gmail.com> wrote:
> Daniel J Blueman wrote:
> > I'll grab kernel logs from the legacy ATA boot; what else can help
> > debug this issue? No problem testing patches too.
>
> Yeap, please post the old log.

Not much actually - perhaps I need to enable some debugging:

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hdc: SanDisk SDCFX-4096, CFA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 8027712 sectors (4110 MB) w/1KiB Cache, CHS=7964/16/63
 hdc: hdc1 hdc2 hdc3

> > --- [2]
> > ata2.00: limiting speed to UDMA/33:PIO4
> > ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata2: soft resetting port
> > ata2.00: configured for UDMA/33
> > ata2: EH complete
>
> What happens after this?

More EH occurs - I've left it for ~5 mins, but let me know if longer
would give more information, eg if it converges on a lower speed.

Would it be useful to compare some of the port setup registers in the
working and non-working cases? Or any other debug I can grab?
-- 
Daniel J Blueman
