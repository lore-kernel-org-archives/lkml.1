Return-Path: <linux-kernel-owner+w=401wt.eu-S1422667AbXDSVzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbXDSVzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXDSVzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:55:39 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:38346 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422667AbXDSVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:55:38 -0400
Subject: Re: [linux-dvb] Re: [video4linux-cvs] [hg:v4l-dvb] Add support for
	Opera S1- DVB-USB
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-dvb@linuxtv.org,
       Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <4627D74A.4090304@gmail.com>
References: <E1HeXiw-0001Ct-0o@www.linuxtv.org>
	 <4627858A.6060209@linuxtv.org> <4627B959.8070601@freenet.de>
	 <4627D407.10105@linuxtv.org>
	 <1177015513.6002.40.camel@matwk009568.brasiltelecom.intra.corp>
	 <4627D74A.4090304@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 19 Apr 2007 23:58:47 +0200
Message-Id: <1177019927.3166.8.camel@pc06.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 20.04.2007, 00:55 +0400 schrieb Manu Abraham:
> Mauro Carvalho Chehab wrote:
> > Em Qui, 2007-04-19 às 16:41 -0400, Michael Krufky escreveu:
> >> Marco Gittler wrote:
> >>> this patch has applied the hints from mkrufky (dvb_attach,
> >>> firmware-naming)
> >>> and also one working rewrite of the i2c addresses stuff to fit the
> >>> kernel i2c reqs.
> >>>
> >>> Signed-off-by: Marco Gittler<g.marco@freenet.de>
> >>> diff -r c8b73ec18b42 linux/drivers/media/dvb/dvb-usb/opera1.c
> >>> --- a/linux/drivers/media/dvb/dvb-usb/opera1.c	Thu Apr 19 12:04:50 2007 -0300
> >>> +++ b/linux/drivers/media/dvb/dvb-usb/opera1.c	Thu Apr 19 20:38:01 2007 +0200
> >>> @@ -25,6 +25,13 @@
> >>>  #define REG_20_SYMBOLRATE_BYTE1 0x20
> >>>  #define REG_21_SYMBOLRATE_BYTE2 0x21
> >>>  
> >>> +#define ADDR_C0_TUNER (0xc0>>1)
> >>> +#define ADDR_D0_PLL (0xd0>>1)
> >>>   
> >> I don't like these two #define's.  These i2c addresses need only be
> >> specified once, in the config structs / frontendfoo_attach calls for the
> >> tuner / demod.
> >>
> >> Better to just put them in as constants like all of the other dvb drivers.
> > 
> > I prefer the way it is. We should really avoid having magic numbers
> > inside the code. The alias here helps to know that 0x60 is tuner addres
> > and 0x68 the pll.
> 
> 
> Following a project's coding styles and conventions is "respecting" a
> project
> 
> Manu
> 

Hi,

the other natural place for this should be the LKML to get more _good_
arguments, instead of hanging soon in some "respect" stuff again.

Cheers,
Hermann
 


