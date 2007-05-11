Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXEKNzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXEKNzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXEKNzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:55:42 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:36342 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbXEKNzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:55:42 -0400
Message-ID: <1178891741.464475dd1b947@imp.free.fr>
Date: Fri, 11 May 2007 15:55:41 +0200
From: Remi Colinet <remi.colinet@free.fr>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
References: <1178802325.46431895e9469@imp.free.fr> <20070510185021.c3d28048.akpm@linux-foundation.org> <200705110047.04933.dtor@insightbb.com>
In-Reply-To: <200705110047.04933.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 81.255.27.251
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Selon Dmitry Torokhov <dtor@insightbb.com>:

> Hi Remi,
>
> On Thursday 10 May 2007 21:50, Andrew Morton wrote:
> > On Thu, 10 May 2007 15:05:25 +0200
> > Remi Colinet <remi.colinet@free.fr> wrote:
> >
> > > My D610 ALPS Glide Point is unresponsive with 2.6.21-mm1 patch.
> > > No problem noticed with 2.6.21.
> > >
> > > The culprit seems to be git-input. I have applied 2.6.21-mm1 on top of
> 2.6.21
> > > and then removed git-input patch. It is ok since then.
>
> Have you tried any other -mm? Also, does it help if you stick
>
Tried 2.6.21-mm3. The GlidePoint is still unresponsive.


> 	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
>
> at the very beginning of psmouse_initialize() in
> drivers/input/mouse/psmouse-base.c?
>

Going to try it ...

In fact, I already added the following line at the begining of each function in
drivers/input/mouse/alps.c

printk(KERN_ERR "start of function ...\n");

But no message is displayed when using the Glide Point. Interrupt are not
raised. The alps driver is not called by the i8042 handler.

Remi Colinet

> --
> Dmitry
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


