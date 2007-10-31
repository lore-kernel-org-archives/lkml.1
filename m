Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXJaUO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXJaUO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXJaUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:14:19 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37460 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754067AbXJaUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:14:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TFOT4Q859zEpwQPuW01Niym/gxhQgseXpQuFHfZLj9C/uCWDrVKw2QT9A6RUrgrM0/fdc8JIdfUT/FfTJIoqec16Sf9n9nDk4flA3P3hkE/l3nR/4acqN6raibHRfSeiYh0s9XWoEE7jmMqhQJ7g46m/wh+gYsm9ODW22lNga+s=  ;
X-YMail-OSG: VQ4FhgcVM1kAEQBuxjksn6leuYStWYbpWXrjYsfiV.8R4d__pqbskSXNWSRkGXVDCG_ic9tiEw--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Wed, 31 Oct 2007 13:14:00 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, bryan.wu@analog.com,
       "Sonic Zhang" <sonic.zhang@analog.com>, linux-kernel@vger.kernel.org
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <200710311201.29643.david-b@pacbell.net> <8bd0f97a0710311216l25f89b37v356fd44d7c1999da@mail.gmail.com>
In-Reply-To: <8bd0f97a0710311216l25f89b37v356fd44d7c1999da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311314.00465.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > pretty much all SPI flashes have two read commands ("slow" and "fast"
> > > as they're typically called).
> >
> > Not DataFlash.
> 
> doesnt it ?  AT45DB642D says 0x0B is fast (up to 66mhz) while 0x03 (up to 33mhz)

And ...041B, ...081B, ...161B, ...321, ...321C, and others don't.
(From a quick scan of datasheets I have locally...)

Those 0x0B and 0x03 commands are "new", and have never been
used by the Linux DataFlash drivers.

