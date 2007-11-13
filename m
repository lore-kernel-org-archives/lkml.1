Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXKMP2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXKMP2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXKMP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:28:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58027 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754106AbXKMP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:28:26 -0500
Date: Tue, 13 Nov 2007 15:27:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Allen Martin" <AMartin@nvidia.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <liml@rtr.ca>,
       "Riki Oktarianto" <rkoktarianto@gmail.com>,
       <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071113152727.45b71939@the-village.bc.nu>
In-Reply-To: <F72FA20C31DD4F4C997B91C5B3690A095054A2@hqemmail07.nvidia.com>
References: <20071109020235.GA2031@ceren>
	<20071109023129.GA25581@havoc.gtf.org>
	<4733D421.7000505@rtr.ca>
	<20071109034622.GB25581@havoc.gtf.org>
	<20071109120425.543971bf@the-village.bc.nu>
	<47351FE1.4000001@garzik.org>
	<DBFABB80F7FD3143A911F9E6CFD477B0329351A3@hqemmail02.nvidia.com>
	<473600B6.5070103@garzik.org>
	<F72FA20C31DD4F4C997B91C5B3690A095054A2@hqemmail07.nvidia.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What I'm worred about is SMI traps implemented in the SBIOS for AHCI
> workarounds that may be disabled when in IDE mode.

For Nvidia devices those would only be present if there were problems
with the AHCI hardware right, which would mean you could simply tell us
what workarounds to implement.

> I believe most of the issues with sata_nv have been due to lack of
> documentation of ADMA and swNCQ.  The NVIDA AHCI controllers that

I am glad Nvidia accept this point. It would be nice to see it fixed.

> I'm with you that AHCI mode is superior and should be used whenever
> possible, but it probably comes as no suprise that almost all the
> hardware/BIOS testing is done with Windows, and operating the hardware
> in a mode that Windows doesn't (enabling AHCI in classcode 0101) seems
> like asking for trouble.

I agree we must be careful, for example we should put the controller back
into its boot mode before suspending so that we can reasonably expect the
BIOS to handle suspend/resume. And we certainly need an override option
in one direction or the other.

Nevertheless you don't make progress by limiting yourself to avoid
breaking the most ancient system. We gave up having a man walking in front
of cars with a red flag a long time ago.

Alan
