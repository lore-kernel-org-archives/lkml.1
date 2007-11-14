Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbXKNMA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbXKNMA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXKNMAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:00:11 -0500
Received: from mail0.scram.de ([78.47.204.202]:60624 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbXKNMAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:00:09 -0500
X-Spam-Score: -4.056
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <473AE325.8070901@scram.de>
Date: Wed, 14 Nov 2007 12:59:33 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linuxppc-embedded@ozlabs.org, marcelo@kvack.org, scottwood@freescale.com,
       linux-kernel@vger.kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc: Fix fs_enet module build
References: <4739EDA8.6020800@scram.de> <20071113.210926.97725854.davem@davemloft.net>
In-Reply-To: <20071113.210926.97725854.davem@davemloft.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> This is truly ugly and creates an unnecessarily hard to
> maintain and complex driver.
> 
> Please find a way to fix this for real, so that the
> PPC_CPM_NEW_BINDING ifdef is not necessary at all and
> things get built modular or not naturally as we handle
> things for other cases like this.

I know it's ugly, however, module building is completely
broken right now and I just want to provide a quick and
ugly fix until both that ppc->powerpc transition and the
new binding transition are over. Noone wants to touch the
old stuff any more as it's a pita and it's already scheduled
for removal in a couple of months.

Thanks,
Jochen
