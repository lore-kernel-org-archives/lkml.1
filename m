Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZAVInk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZAVInk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZAVIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:43:29 -0500
Received: from smtp05.msg.oleane.net ([62.161.4.5]:47829 "EHLO
	smtp05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZAVIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:43:28 -0500
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 03:43:28 EST
X-DKIM: Sendmail DKIM Filter v2.7.2 smtp05.msg.oleane.net n0M8LKu7026215
Authentication-Results: smtp05.msg.oleane.net; dkim=none (no signature)
	header.i=unknown; dkim-adsp=none
X-Oleane-Rep: REPA
From: "Tosoni" <jp.tosoni@acksys.fr>
To: "'Michael Bramer'" <michael@debsupport.de>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Niels de Vos'" <niels.devos@wincor-nixdorf.com>,
       "'Paulius Zaleckas'" <paulius.zaleckas@teltonika.lt>,
       <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: RE: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Date: Thu, 22 Jan 2009 09:21:17 +0100
Message-ID: <6E0880DF84464BF2AA0275ABFFCCDAF2@acksys.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2910.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: <20090121234241.GB10645@deb-support.de>
Importance: Normal
X-Spam-Flag: NO
X-PMX-Spam: Probability=8%
X-PFSI-Info: PMX 5.5.0.356843, Antispam-Engine: 2.6.1.350677, Antispam-Data: 2009.1.22.80149 (no antivirus check)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [mailto:linux-serial-owner@vger.kernel.org]On Behalf Of Michael Bramer
>
> On Wed, Jan 21, 2009 at 12:32:15PM +0000, Alan Cox wrote:
> > > >>  static struct pci_device_id serial_pci_tbl[] = {
> > > >> +       {       PCI_VENDOR_ID_ADVANTECH,
> PCI_DEVICE_ID_ADVANTECH_PCI3620,
> > > >> +               0x3620, PCI_ANY_ID, 0, 0,
> > >
> > > Why not use PCI_VENDOR_ID_ADVANTECH as PCI_SUBVENDOR_ID too?
> >
> > The Advantech vendor id is not 0x3620. This confused me as
> well which is
> > why I asked for an lspci. Advantech has stuck the device id in the
> > subvendor bits and '1' in the subdevice (so it should be 1 not
> > PCI_ANY_ID).
>
> is this better?
>
> +       {       PCI_VENDOR_ID_ADVANTECH,
> PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               PCI_DEVICE_ID_ADVANTECH_PCI3620, 1, 0, 0,

Since the name describes a device id where it should be a (sub)vendor id,
I would suggest that you add a line of comment to explain the case.
So that no one will be tempted to change it back to PCI_VENDOR_ID_ADVANTECH
in the future.

Regards


