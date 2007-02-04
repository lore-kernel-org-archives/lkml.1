Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbXBDTWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbXBDTWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXBDTWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:22:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53099 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752303AbXBDTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:22:03 -0500
Date: Sun, 4 Feb 2007 19:34:41 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: "Patrick Ale" <patrick.ale@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: More pata_ stuff
Message-ID: <20070204193441.6746bbca@localhost.localdomain>
In-Reply-To: <200702041910.46421.s0348365@sms.ed.ac.uk>
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	<45C619FC.3040804@shaw.ca>
	<8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	<200702041910.46421.s0348365@sms.ed.ac.uk>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And this config has clearly:
> 
> # CONFIG_ATA_PIIX is not set
> 
> Which for a PIIX4 chipset is what you want. Somewhat confusingly:
> 
> CONFIG_PATA_MPIIX=y
> CONFIG_PATA_OLDPIIX=y
> 
> Should be "n", I've been told.

Setthing them as well will cause no problems.

ATA_PIIX drives the Intel PIIX3,PIIX4,ICH series of devices both in PATA
and SATA mode

PATA_MPIIX drives the original mobile PIIX

PATA_OLDPIIX drives the PIIX (the original not PIIX3,4, etc)

People do find that confusing so if there is any rewording for
Configure.help that would have made it easier and more obvious let me know
