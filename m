Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbXE1TSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbXE1TSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763193AbXE1TSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:18:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:61035 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbXE1TR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OwR86zxU/6yd5nMa/hKwqUfTLThBUPV4cHMoF4DXmnTa+mxIZhgv38NwfENcizLrRPk8kGqdnUsZ/mcjSdFGuwFBWNvUhRKtdDx31GmGPMRWivUGdnnz/GL4iguRcumKJJAgT41HsxrogDjwSdonH4/Qelhkn2FAv2UFi0IVbB8=
Message-ID: <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
Date: Mon, 28 May 2007 21:17:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Jiri Slaby" <jirislaby@gmail.com>, video4linux-list@redhat.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1180378677.21547.189.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2172422218943432279@wsc.cz> <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <1180378677.21547.189.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Seg, 2007-05-28 às 17:14 +0200, Markus Rechberger escreveu:
>
> > > > +/*
> > > > + * Bayer conversion
> > > > + */
> > >
> > > We don't do format conversions in kernel. Instead, you should return a
> > > proper Bayer Fourcc format (like V4L2_PIX_FMT_SBGGR8).
> > >
> >
> > It's ok in his case since most userspace applications do not support
> > this format, it helps noone if there's a driver out there which isn't
> > supported by most userspace applications and I don't expect that all
> > applications will add a conversion for that format soon.
> > This would moreover raise the question about a userspace library,
> > though there are many more important issues which are outstanding and
> > which got smashed down.
>
> As Luca pointed, if we add conversion for one driver, we should add for
> the rest.
>
> Instead, it would be better if Jiri sends the decoding and the rescaling
> stuff as a patch to v4l2-apps/lib, starting the API decoding library.
> Once we have a library, we can ask the userspace developers to use it
> for the formats not recognized by their userspace apps.
>

I think it would be better to evaluate existing solutions (eg. libpw).
Instead starting another one (which would lack any design since I
haven't seen any thread that was picking together requirements),
improving that existing one might also be helpful for applications
like ekiga.
As for libpw it also supports colourspace conversion and software
scaling, the used algorithms seem to need some improvement, but alot
work has already been done there.
Of course other libraries should also be taken into account, maybe
someone knows something better which is more complete.

Markus
