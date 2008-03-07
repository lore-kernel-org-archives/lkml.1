Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbYCGLm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbYCGLm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYCGLmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:42:47 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:34780 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004AbYCGLmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:42:46 -0500
Date: Fri, 7 Mar 2008 12:40:58 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@smile.org.ua>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SDIO] add vendor and product pair for SQN1130
Message-ID: <20080307124058.052a62ba@mjolnir.drzeus.cx>
In-Reply-To: <20080307024526.17ff6401.akpm@linux-foundation.org>
References: <12048773103435-git-send-email-andy@smile.org.ua>
	<20080307024526.17ff6401.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 02:45:26 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri,  7 Mar 2008 10:08:30 +0200 Andy Shevchenko <andy@smile.org.ua> wrote:
> 
> > Add the vendor and product ids for Sequans SQN1130 WiMAX chipset.
> > ---
> >  include/linux/mmc/sdio_ids.h |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> > index ea1bf5b..d1b9883 100644
> > --- a/include/linux/mmc/sdio_ids.h
> > +++ b/include/linux/mmc/sdio_ids.h
> > @@ -26,4 +26,7 @@
> >  #define SDIO_VENDOR_ID_MARVELL			0x02df
> >  #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
> >  
> > +#define SDIO_VENDOR_ID_SEQUANS			0x039d
> > +#define SDIO_DEVICE_ID_SEQUANS_SQN1130		0x046a
> > +
> 
> There's no point in adding these unless there's actually some code there
> which _uses_ them?

Agreed. This is just noise.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
