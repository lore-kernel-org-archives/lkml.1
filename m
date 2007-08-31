Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXHaDfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXHaDfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXHaDf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:35:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49754 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755771AbXHaDf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:35:27 -0400
Date: Thu, 30 Aug 2007 20:35:24 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc4][RESEND] ahci: RAID mode SATA patch for Intel Tolapai
Message-ID: <20070831033524.GH114642@sgi.com>
References: <200708301753.31692.jason.d.gaston@intel.com> <39B20DF628532344BC7A2692CB6AEE0701B5BC46@orsmsx420.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE0701B5BC46@orsmsx420.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 06:00:26PM -0700, Gaston, Jason D wrote:
> >
> >Resend without wordwrap.
> >
> >This patch adds the Intel Tolapai RAID controller DID's for SATA support.
> >
> >Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> >
> >--- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27
> >18:32:35.000000000 -0700
> >+++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28 16:58:11.000000000 -
> >0700
> >@@ -411,6 +411,8 @@
> > 	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
> > 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
> > 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
> >+	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
> >+	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
> >
> > 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
> > 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> 
> 
> I am having trouble sending these patches.  When I look in the LKML.org message archive, I see "=A0" and "=20" in the messages.  I am using KMail to send these, I have wordwrap turned off and am inserting the patch file.  Does anyone know what I am doing wrong?


It seems that you have some 8-bit characters in the email.
The '=20' in the middle of the patch was stripped for me by sendmail,
apparently, but you can see the character before your name in the
'Signed-off-by' line.

Maybe try mutt?
