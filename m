Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbYD1Bvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbYD1Bvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYD1Bvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:51:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:35209 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbYD1Bvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:51:36 -0400
Message-ID: <a24804730804271851j61ded9c2tf1c15b6da845050c@mail.gmail.com>
Date: Sun, 27 Apr 2008 18:51:35 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] fix warning: remove unused static function in drivers/char/ip2/i2ellis.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48142E5B.3000109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a24804730804270009x3398a190wf68e52280015fc7f@mail.gmail.com>
	 <48142E5B.3000109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I did compile it, but I now realize I had compiled the computone
driver to be linked statically, but iiEllisCleanup() is only called
when the driver is built as a module. What is the appropriate cleanup
code path for non-modular drivers?


chris


On Sun, Apr 27, 2008 at 12:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 04/27/2008 09:09 AM, Chris Peterson wrote:
>
> > This patch against linux-2.6.25-git7.
> >
> > chris
> >
> >
> > Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
> > ---
> > diff -Naur linux-2.6.25-git7/drivers/char/ip2/i2ellis.c
> > linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c
> > --- linux-2.6.25-git7/drivers/char/ip2/i2ellis.c        2008-04-25
> > 22:47:01.000000000 -0700
> > +++ linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c  2008-04-25
> > 23:19:57.000000000 -0700
> > @@ -86,22 +86,6 @@
> >  }
> >
> >
> //******************************************************************************
> > -// Function:   iiEllisCleanup()
> > -// Parameters: None
> > -//
> > -// Returns:    Nothing
> > -//
> > -// Description:
> > -//
> > -// This routine performs any required cleanup of the iiEllis subsystem.
> > -//
> >
> -//******************************************************************************
> > -static void
> > -iiEllisCleanup(void)
> > -{
> > -}
> >
>
>  Well, have you tried to even build it? The .c file is *included* into
> i2main.c where this function is used.
>
>  NAK
>
