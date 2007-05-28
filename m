Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbXE1S66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbXE1S66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXE1S6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:58:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34319 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXE1S6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:58:50 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, video4linux-list@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 28 May 2007 15:57:57 -0300
Message-Id: <1180378677.21547.189.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Seg, 2007-05-28 às 17:14 +0200, Markus Rechberger escreveu:

> > > +/*
> > > + * Bayer conversion
> > > + */
> >
> > We don't do format conversions in kernel. Instead, you should return a
> > proper Bayer Fourcc format (like V4L2_PIX_FMT_SBGGR8).
> >
> 
> It's ok in his case since most userspace applications do not support
> this format, it helps noone if there's a driver out there which isn't
> supported by most userspace applications and I don't expect that all
> applications will add a conversion for that format soon.
> This would moreover raise the question about a userspace library,
> though there are many more important issues which are outstanding and
> which got smashed down.

As Luca pointed, if we add conversion for one driver, we should add for
the rest. 

Instead, it would be better if Jiri sends the decoding and the rescaling
stuff as a patch to v4l2-apps/lib, starting the API decoding library.
Once we have a library, we can ask the userspace developers to use it
for the formats not recognized by their userspace apps.

Cheers,
Mauro

