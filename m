Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbXE1QnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbXE1QnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXE1QnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:43:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:30498 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXE1Qm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JGA11zr4TmUDDafJYQmtC/VnZmQ8LxcGEmB16jbw1jeSFlXhGPqid54HTZ/8JjEEcb/dNvCmdskhwkcxYdZI4hgLXsWNEUjGHxRxduDvNAfkdIrFz9sCXcz4fkl1bvtIkjN8SeXh3dBz1vmhEbKr4Evli3+rxjMrYdrNYWoj08Y=
Message-ID: <d9def9db0705280942w47143ea9wceea9e0847c39d5@mail.gmail.com>
Date: Mon, 28 May 2007 18:42:57 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Luca Risolia" <luca.risolia@studio.unibo.it>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705281828.57651.luca.risolia@studio.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2172422218943432279@wsc.cz> <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <200705281828.57651.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Luca Risolia <luca.risolia@studio.unibo.it> wrote:
> On Monday 28 May 2007 17:14:51 Markus Rechberger wrote:
> > On 5/28/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > We don't do format conversions in kernel. Instead, you should return a
> > > proper Bayer Fourcc format (like V4L2_PIX_FMT_SBGGR8).
> >
> > It's ok in his case since most userspace applications do not support
> > this format, it helps noone if there's a driver out there which isn't
> > supported by most userspace applications and I don't expect that all
> > applications will add a conversion for that format soon.
> > This would moreover raise the question about a userspace library,
> > though there are many more important issues which are outstanding and
> > which got smashed down.
>
> Markus, I do think the userspace library is THE real problem with the whole
> V4L subsystem. It's annoying to keep repeating why these convertions should
> be done outside the kernel, be them in a library or not. I deliberatly never
> implemented the above convertion in the drivers that I have been maintaing
> for years, since I had the idea that this approach whould have pushed the
> developers to write the _best_ algorithm by themselves. I still think it's
> the correct approach, but now I give up. Mauro, if you are planning to
> accept
> this BayerToSomething color convertion, be also prepared to accept the same
> convertion for other drivers in the kernel. Rules are made for everyone.
>

Initially asking for help doesn't lead anywhere either because most
people aren't skilled enough or have personal issues with helping out
at linuxtv.
I'm fine with the conversion, a valid point is scaling, this is
something userspace can handle already.
And as I mentioned there are more important issues out there which
should be handled first, but they're greatly getting ignored again
(just as usual, and this also takes regressions and current
implementation bugs in account).

Markus
