Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXKNShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXKNShT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXKNShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:37:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:18401 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXKNShA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:37:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Wed, 14 Nov 2007 10:36:40 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] Add quirk to set AHCI mode on ICH boards
Date: Wed, 14 Nov 2007 10:35:26 -0800
Message-ID: <F72FA20C31DD4F4C997B91C5B3690A095054A7@hqemmail07.nvidia.com>
In-Reply-To: <20071113152727.45b71939@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add quirk to set AHCI mode on ICH boards
Thread-Index: AcgmCdUd4aYdsYSmRvqUukjk60A+lwA31mOw
References: <20071109020235.GA2031@ceren><20071109023129.GA25581@havoc.gtf.org><4733D421.7000505@rtr.ca><20071109034622.GB25581@havoc.gtf.org><20071109120425.543971bf@the-village.bc.nu><47351FE1.4000001@garzik.org><DBFABB80F7FD3143A911F9E6CFD477B0329351A3@hqemmail02.nvidia.com><473600B6.5070103@garzik.org><F72FA20C31DD4F4C997B91C5B3690A095054A2@hqemmail07.nvidia.com> <20071113152727.45b71939@the-village.bc.nu>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <liml@rtr.ca>,
       "Riki Oktarianto" <rkoktarianto@gmail.com>,
       <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 18:35:26.0907 (UTC) FILETIME=[202E50B0:01C826ED]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What I'm worred about is SMI traps implemented in the SBIOS for AHCI
> > workarounds that may be disabled when in IDE mode.
> 
> For Nvidia devices those would only be present if there were problems
> with the AHCI hardware right, which would mean you could 
> simply tell us
> what workarounds to implement.

Errata for which there is an SBIOS workaround are generally only
released to BIOS vendors and under NDA.  If Linux users were impacted by
such a bug we would most likely release a patch, but a much more likely
scenario is that it slips through the cracks because it's not a
configuration we would test in our QA.  So a small minority of users
that are running AHCI in class code 0101 would get some very rare but
serious errors that would be impossible to debug.

> > I believe most of the issues with sata_nv have been due to lack of
> > documentation of ADMA and swNCQ.  The NVIDA AHCI controllers that
> 
> I am glad Nvidia accept this point. It would be nice to see it fixed.

I don't have any say over that, but it's probably unlikely to be fixed.
Going forward we're only using open standards for storage.

-Allen
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
