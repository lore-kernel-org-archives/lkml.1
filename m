Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZKNAPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZKNAPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZKNAPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:15:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:21166 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664AbZKNAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:15:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=dynVNiEtt8rKwI6XEWKIg9sZeV0idLwkrgPyk0ESw5N5StpffcgGBq23+Av4KxdCXp
         1dkM2Yo3wnnwJw9gaQUmpPrHP7I9rv3/EgdDHkOz8gOuSUU4yw4z1xmbyGOkh0TtEuWV
         v8e8FK1QSFsWdbyKXduTDHk06XVIE5dzh1hpw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 01:14:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <4AFCC0D4.9020708@gmail.com> <20091113182515.38fb3793@lxorguk.ukuu.org.uk> <200911140046.29450.bzolnier@gmail.com>
In-Reply-To: <200911140046.29450.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911140114.24766.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009 00:46:29 Bartlomiej Zolnierkiewicz wrote:
> On Friday 13 November 2009 19:25:15 Alan Cox wrote:
> > > Fine but please update status of following host drivers that were
> > > marked as "stable" prematurely by commit e3389cb first:
> > > 
> > > PATA_PDC_OLD: needs to be marked as EXPERIMENTAL (or just BROKEN)
> > > - known reliability problems with UDMA
> > 
> > A few odd reports apparently linked to specific chip revs. It's at
> > least as stable as the old IDE one which doesn't work on my hardware. I'd
> 
> Skipping the technical merit of the quoted text for the moment -- I find
> the fact that you keep calling the present IDE host drivers (that many
> developers helped to fix) as "old" ones or "buggy" ones rather degrading
> for their (this includes me of course) hard work.
> 
> Especially given your complete lack of familiarity with post-2004 changes.
> 
> See for yourself, *50* mostly _trivial_ patches during *5* years:
> 
> [ "git log --follow --since="5 years ago" drivers/ide|grep "Author: Alan Cox" -B1 -A3"
>   output edited for easier reading ]

I've also looked at ATA side of the things for the last *3* years now:

$ git log --follow --since="3 years ago" drivers/ata|grep "Author: Alan Cox"|wc -l
173

[ ~5 patches a month and most of the work was to bring PATA on the level that
  old IDE code has offered back in 2005.. ]

also before people start calling me names or teach me about "accumulated
credibility" concept:

I'm in no way trying to deny people's past achievements (hey, I got inspired
by Alan's work myself in early days) but I would like to raise the awareness
that these days it is a way more difficult than it was in the past to make
significant and/or large scale changes so new people are stuck in Catch22 when
it comes to "accumulated credibility"..

-- 
Bartlomiej Zolnierkiewicz
