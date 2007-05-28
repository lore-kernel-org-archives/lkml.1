Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbXE1Q3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbXE1Q3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbXE1Q3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:29:12 -0400
Received: from smtp-out4.libero.it ([212.52.84.46]:48473 "EHLO
	smtp-out4.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE1Q3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:29:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGagWkaXTNwi/2dsb2JhbAA
From: Luca Risolia <luca.risolia@studio.unibo.it>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Date: Mon, 28 May 2007 18:28:57 +0200
User-Agent: KMail/1.9.6
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com, Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <2172422218943432279@wsc.cz> <1180364420.21547.160.camel@localhost> <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
In-Reply-To: <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281828.57651.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 17:14:51 Markus Rechberger wrote:
> On 5/28/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > We don't do format conversions in kernel. Instead, you should return a
> > proper Bayer Fourcc format (like V4L2_PIX_FMT_SBGGR8).
>
> It's ok in his case since most userspace applications do not support
> this format, it helps noone if there's a driver out there which isn't
> supported by most userspace applications and I don't expect that all
> applications will add a conversion for that format soon.
> This would moreover raise the question about a userspace library,
> though there are many more important issues which are outstanding and
> which got smashed down.

Markus, I do think the userspace library is THE real problem with the whole 
V4L subsystem. It's annoying to keep repeating why these convertions should 
be done outside the kernel, be them in a library or not. I deliberatly never 
implemented the above convertion in the drivers that I have been maintaing 
for years, since I had the idea that this approach whould have pushed the 
developers to write the _best_ algorithm by themselves. I still think it's 
the correct approach, but now I give up. Mauro, if you are planning to accept 
this BayerToSomething color convertion, be also prepared to accept the same 
convertion for other drivers in the kernel. Rules are made for everyone.

Best regards,
Luca
