Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYHDNY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYHDNY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHDNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:24:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYHDNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:24:45 -0400
Date: Mon, 4 Aug 2008 10:24:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Douglas Landgraf <dougsland@gmail.com>
Subject: Re: bad CONFIG variable references from Makefiles
Message-ID: <20080804102421.588e2e56@gaivota.chehab.org>
In-Reply-To: <20080728214841.GG7713@cs181140183.pp.htv.fi>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
	<20080728214841.GG7713@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Tue, 29 Jul 2008 00:48:41 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> > 
> >   a complete list of all references to non-existent CONFIG variables
> > exclusively from Makefiles in the tree.  since the list is so short,
> > i'm not bothering to break it up by subsystem or arch.  enjoy.
> >...
> > ===== RADIO_MIROPCM20 =====
> > ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
> > ===== RADIO_MIROPCM20_RDS =====
> > ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) +=
> > miropcm20-rds.o
> >...
> 
> Mauro, 1.5 years ago you said you wanted this code to stay for having it 
> perhaps ported to ALSA.
> 
> Do you still want it to stay or could it be removed now (if anyone 
> suddenly feels the desire to work on it the code is still in older 
> kernels)?
> 

Douglas started working on this, but never finished a changeset. Since nobody
ever complained about this during this 1.5 years period, IMO, we should just
drop it.

Cheers,
Mauro
