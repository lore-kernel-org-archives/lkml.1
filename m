Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZFYFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZFYFrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFYFrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:47:15 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1575 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:47:15 -0400
Subject: Re: [PATCH 19/19] sound: Use PCI_VDEVICE
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org
In-Reply-To: <s5hocscna17.wl%tiwai@suse.de>
References: <cover.1245906151.git.joe@perches.com>
	 <e27f875baa15d3d3e34c2a005cea9d702e822c57.1245906153.git.joe@perches.com>
	 <s5hocscna17.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 22:47:12 -0700
Message-Id: <1245908832.395.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 07:43 +0200, Takashi Iwai wrote:
> At Wed, 24 Jun 2009 22:13:35 -0700,
> Joe Perches wrote:
> > diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
> > index 18f4d1e..d589bbc 100644
> > --- a/sound/pci/ens1370.c
> > +++ b/sound/pci/ens1370.c
> > @@ -445,11 +445,11 @@ static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id);
> >  
> >  static struct pci_device_id snd_audiopci_ids[] = {
> >  #ifdef CHIP1370
> > -	{ 0x1274, 0x5000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1370 */
> > +	{ PCI_VDEVICE(ENSONIQ, 0x5000), 0, },	/* ES1370 */
> >  #endif
> >  #ifdef CHIP1371
> > -	{ 0x1274, 0x1371, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1371 */
> > -	{ 0x1274, 0x5880, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1373 - CT5880 */
> > +	{ PCI_VDEVICE(ENSONIQ, 0x1371), 0, },	/* ES1371 */
> > +	{ PCI_VDEVICE(ENSONIQ, 0x5880), 0, },	/* ES1373 - CT5880 */
> >  	{ 0x1102, 0x8938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* Ectiva EV1938 */
> 
> Any reason not to covert this?

Not really, 0x1102 maps to 2 PCI entries, CREATIVE and ECTIVA.
The script wouldn't know which is appropriate to use, so I skipped it.

The script is in 0/19: http://lkml.org/lkml/2009/6/25/21



