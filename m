Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbXGMT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbXGMT6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXGMT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:58:26 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:35166 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757684AbXGMT60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:58:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=52QGURNF6Jlq2HuU95uiZRpRmBx/yjTCBdekUXLsMpqnAK7UMXlTQ5a0wigQHWV1BxDmFB7V7CKs5jdFL7iXAnlCnwNjVGnAFiPaK2fgkKXf47E3JJzqGJSD6fcb2VViu60jAP5wo8A8hGTr8lb/jxKkhvK4SLIhWxo94YQA/Eo=  ;
X-YMail-OSG: dVXiqP0VM1mnmLErQWbKY7Z.Qqx2yT9omH8Czrlkb.CP51g7
From: David Brownell <david-b@pacbell.net>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [RESEND patch 2.6.22-rc4 1/2] ads7846 sample settling
Date: Fri, 13 Jul 2007 12:58:23 -0700
User-Agent: KMail/1.9.6
Cc: "Semih Hazar" <semih.hazar@indefia.com>,
       "Imre Deak" <imre.deak@solidboot.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
References: <200707131129.10885.david-b@pacbell.net> <d120d5000707131201x4ccfb41bk5fe610c299869514@mail.gmail.com>
In-Reply-To: <d120d5000707131201x4ccfb41bk5fe610c299869514@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131258.23543.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007, Dmitry Torokhov wrote:
> HI David,
> 
> On 7/13/07, David Brownell <david-b@pacbell.net> wrote:
> > From: Semih Hazar <semih.hazar@indefia.com>
> >
> > The ads7846 driver has support for filtering, but when the chip gets
> > deselected between samples this causes noise. This patch adds support
> > for an optional settling delay time, so that two consecutive samples
> > will be taken with the specified delay time apart.  This ensures that
> > the chip won't be deselected, so the noise won't appear.
> >
> 
> 
> Sorry for being unresponsive.

It happens to all of us sometimes!  No real problem.


> 	I have both patches in my tree and I 
> will push them to Linus with my next batch for 2.6.23-pre-rc1.

Great, that's what I wanted to see happen.


Watching this touchscreen driver evolve has been interesting;
I hadn't realized it took quite so much work to get accurate
measurements!  Some touchscreen controllers seem to do the
sample quality improvement in hardware (or firmware), but this
seems to be the only driver doing this much of the work itself.

- Dave

