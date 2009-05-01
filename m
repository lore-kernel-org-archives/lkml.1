Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZEALRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZEALRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbZEALQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:16:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40502 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZEALQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=I81N04IwT/UnYwz6HjlZO6uArv0Adtc+Q0qObRxwOeScUoZzRmptdc6XQxbZKIvo9q
         8InJBsBjOiPHs6Xl8HuvXP+HBplOHQRZYGPw16JFV7gGhDTBrq91i0cUjTuv8vx4G0St
         H2CJJf1+XaQ6+ihahdg6tbkue9OsxRGHiarsc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: =?utf-8?q?Rog=C3=A9rio_Brito?= <rbrito@users.sf.net>
Subject: Re: Quick question about libata and hdparm
Date: Fri, 1 May 2009 13:20:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <6540c930904232000t76aa4954l4f5cee5bad64aacb@mail.gmail.com> <20090501091804.GB29466@ime.usp.br>
In-Reply-To: <20090501091804.GB29466@ime.usp.br>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905011320.57491.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009 11:18:04 Rogério Brito wrote:
> Hi, Bart and other people.
> 
> On Apr 24 2009, Rogério Brito wrote:
> > On 4/23/09, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > > You can try booting with "libata.force=1.00:mwdma2" kernel paramater
> > > to force use of "regular" MWDMA2 transfer mode instead of UDMA ones
> > > so we are sure that the issue is specific to pata_pdc202xx_old +
> > > UDMA.
> > 
> > This *did* work. I see no other error messages, while using multword
> > dma. So I think that this serves for us to rule out some unknown
> > variables.
> 
> Is there anything that I can do right now? Just to remember, the
> original IDE driver works without any problems, but I would like to
> migrate everything to libata (and many distributions are already using
> libata by default, even with IDE devices).

DISCLAIMER was there for a reason...

Please ping pata_pdc202xx_old maintainer, libata maintainer or said
distributions about it, not me.

Don't get me wrong.  I would like to help but such problems usually
take really long time to debug (you have to know both stacks, both
drivers and be able to track subtle differences between all of them)
and you have absolutely no guarantee that it will yield any results.

[ Tejun has spent few days on trying to fix pata_ali MWDMA regression
  and he is one of people who really know what they are doing. ]

I don't have such time and my motivation to help is seriously effected
by behaviors like that seen in:

	http://bugzilla.kernel.org/show_bug.cgi?id=12734

Thanks,
Bart
