Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYBGMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYBGMHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYBGMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:07:09 -0500
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53447 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbYBGMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:07:07 -0500
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 07:07:06 EST
From: Marc Zyngier <maz@misterjones.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [resend] 3c509: convert to isa_driver and pnp_driver v3
Organization: Metropolis -- Nowhere
References: <200801312012.43447.linux@rainbow-software.org>
	<200802021925.36552.linux@rainbow-software.org>
	<47A4D791.3050700@garzik.org>
	<200802061909.37452.linux@rainbow-software.org>
X-Attribution: maz
Reply-to: maz@misterjones.org
Date: Thu, 07 Feb 2008 12:51:11 +0100
Message-ID: <wrphcglx9w0.fsf@hina.wild-wind.fr.eu.org>
In-Reply-To: <200802061909.37452.linux@rainbow-software.org> (Ondrej Zary's
	message of "Wed, 6 Feb 2008 19:09:35 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.70.139
X-SA-Exim-Rcpt-To: linux@rainbow-software.org, jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ondrej" == Ondrej Zary <linux@rainbow-software.org> writes:

Ondrej> Tested using 3 ISA cards in various combinations of PnP and non-PnP modes.

Ondrej>  #ifdef CONFIG_EISA
Ondrej>  	ret = eisa_driver_register(&el3_eisa_driver);
Ondrej> +	if (!ret)
Ondrej> +		eisa_registeted = 1;
Ondrej>  #endif
                        ^^^^^^^^^^^^^^^

You probably should at least test-compile this driver with CONFIG_EISA
enabled...

Regards,

	M.
-- 
And if you don't know where you're going, any road will take you there...
