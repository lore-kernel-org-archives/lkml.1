Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYEYRJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYEYRJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYEYRJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:09:26 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39623 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYEYRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:09:26 -0400
Date: Sun, 25 May 2008 13:09:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] SERIAL:  Simplify code using ARRAY_SIZE() macro.
In-Reply-To: <483998EC.5080805@gmail.com>
Message-ID: <alpine.LFD.1.10.0805251308420.25842@localhost.localdomain>
References: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain> <483998EC.5080805@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Jiri Slaby wrote:

> On 05/25/2008 01:37 PM, Robert P. J. Day wrote:
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> >  drivers/serial/68328serial.c |    6 +++---
> >  drivers/serial/mcfserial.c   |    5 ++---
> >  2 files changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> > index bbf5bc5..71c56c1 100644
> > --- a/drivers/serial/68328serial.c
> > +++ b/drivers/serial/68328serial.c
> [...]
> > @@ -1413,10 +1413,10 @@ static void m68328_set_baud(void)
> >  	USTCNT = ustcnt & ~USTCNT_TXEN;
> >
> >  again:
> > -	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
> > +	for (i = 0; i < BAUD_TABLE_SIZE); i++)
>
> typo? does this compile?

oh, gack, my bad.  it compiled, then i figured i'd innocently fix up
some white space and pooched it.  sorry.  will resubmit.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
