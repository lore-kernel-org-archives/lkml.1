Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYI3WKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYI3WKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYI3WKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:10:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:37354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYI3WKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:10:22 -0400
Subject: Re: [PATCH] suspend/resume for ATI Mobility Radeon RV350
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Wolfgang Kroener <lkml@azog.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080930140658.GL10156@casella.faui2k3.org>
References: <20080930140658.GL10156@casella.faui2k3.org>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 08:10:10 +1000
Message-Id: <1222812610.9006.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 16:06 +0200, Wolfgang Kroener wrote:
> Hi,
> I have a ATI Mobility Radeon RV350 and similar problems with radeonfb
> described in http://kernel.org/doc/Documentation/power/s2ram.txt
> Adding the device to radeon_workaround_list solves the Problem.
> Please accept the following patch:

Can you resend it with a proper Signed-off-by: line ? Thanks !

Cheers,
Ben.

> --8<--
> --- drivers/video/aty/radeon_pm.c.orig	2008-09-30 15:00:40.988111330 +0200
> +++ drivers/video/aty/radeon_pm.c	2008-09-30 15:14:10.941524474 +0200
> @@ -89,6 +89,9 @@
>  	BUGFIX("Acer Aspire 2010",
>  	       PCI_VENDOR_ID_AI, 0x0061,
>  	       radeon_pm_off, radeon_reinitialize_M10),
> +	BUGFIX("Acer Travelmate 290D/292LMi",
> +	       PCI_VENDOR_ID_AI, 0x005a,
> +	       radeon_pm_off, radeon_reinitialize_M10),
>  	{ .ident = NULL }
>  };
> 
> -->8--
> Kind regards,
> Wolfgang
> 
> P. S. please CC me, because I'm not subscribed to the lkml

