Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYFTUSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYFTUSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbYFTUQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:16:53 -0400
Received: from relay.netbox.cz ([83.240.0.201]:45978 "EHLO relay.netbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598AbYFTUQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:16:51 -0400
Date: Fri, 20 Jun 2008 23:57:23 +0200
From: Zbynek Hrabovsky <hrabosh@t-email.cz>
To: =?ISO-8859-2?Q?Andr=E9?= AUZI <aauzi@users.sourceforge.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       Michel Lespinasse <walken@zoy.org>,
       Nicolas Marot <nicolas.marot@gmail.com>, linux-kernel@vger.kernel.org,
       nicolas <nicolas@nikoland.homelinux.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
Message-Id: <20080620235723.30948f31.hrabosh@t-email.cz>
In-Reply-To: <4852E1F1.4040900@users.sourceforge.net>
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
	<20080613151843.240a62cb@gaivota>
	<4852E1F1.4040900@users.sourceforge.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi André,


Yes, you are right .. most likely. But it used to work when I wrote it. 



Zbynek




On Fri, 13 Jun 2008 23:09:05 +0200
André AUZI <aauzi@users.sourceforge.net> wrote:

> Hi all,
> 
> forgive me if I jump in the conversation without invitation but I've got 
> the same board and basically started the same task as you, Zbynek.
> 
> I'm still stuck with the radio support and your patch seems more 
> advanced on the mpeg side.
> 
> Therefore, would you mind if I ask a question about what's proposed in 
> the cx88-mpeg.c file?
> 
> > diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-mpeg.c
> > --- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 10 15:27:29 2008 -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Fri Jun 13 15:07:34 2008 -0300
> > @@ -148,6 +148,12 @@
> >  			cx_write(TS_SOP_STAT, 0);
> >  			cx_write(TS_VALERR_CNTRL, 0);
> >  			udelay(100);
> > +			break;
> > +		case CX88_BOARD_WINFAST_DTV2000H_2:
> > +			/* switch signal input to antena */
> > +			cx_write(MO_GP0_IO, 0x00017300);
> > +
> > +			cx_write(TS_SOP_STAT, 0x00);
> >  			break;
> >  		default:
> >  			cx_write(TS_SOP_STAT, 0x00);
> >   
> 
> Correct me if I'm wrong but this change doesn't it prevent from 
> processing data coming from the cable input?
> 
> Cheers,
> André
> 
