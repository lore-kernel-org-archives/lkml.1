Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYGMMKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYGMMKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 08:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYGMMKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 08:10:24 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:59583 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbYGMMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 08:10:23 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Sun, 13 Jul 2008 14:10:14 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807131347.14045.linux@rainbow-software.org> <20080713123510.6f47ffdc@lxorguk.ukuu.org.uk>
In-Reply-To: <20080713123510.6f47ffdc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131410.16521.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 July 2008 13:35:10 Alan Cox wrote:
> > The patch below fixes the IDENTIFY problem for me and makes the RAID
> > array accessible. Is it OK or is there a better way to do it?
>
> Probably better to fix it in driver. Right now we don't have a way to
> override the identify reading or post process it cleanly at it821x hacks
> around that but if that was fixed then the special cases can all hide in
> the driver where they belong.

That would be great but it requires some deeper libata and kernel programming 
knowledge.

>
> > +	/* Has LBA48 but advertises neither LBA nor LBA48 */
> > +	{ "Integrated Technology Express Inc", NULL, ATA_HORKAGE_LBA48_FORCE,
> > },
>
> That depends on the firmware revision it seems. Mine are fine

Too bad it doesn't report any firmware revision :( I think that this should 
not harm a working IT8212 controller.

-- 
Ondrej Zary
