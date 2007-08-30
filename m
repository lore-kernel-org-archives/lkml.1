Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXH3ItG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXH3ItG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXH3Isz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:48:55 -0400
Received: from mail0.scram.de ([78.47.204.202]:54412 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbXH3Isy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:48:54 -0400
X-Spam-Score: -4.031
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <46D68466.3060402@scram.de>
Date: Thu, 30 Aug 2007 10:48:38 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppc32/8xx: Fix r3 trashing due to 8MB TLB page instantiation
References: <46D40510.3060805@scram.de> <611B8BA7-89B3-4DA0-A248-0FB57E4654ED@kernel.crashing.org>
In-Reply-To: <611B8BA7-89B3-4DA0-A248-0FB57E4654ED@kernel.crashing.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> do we need this in arch/powerpc as well?

No. At least not until these patches are applied to powerpc, as well:

8f069b1a90bd97bf6d59a02ecabf0173d9175609 [PATCH] powerpc/8xx: Use 8MB D-TLB's for kernel static mapping faults
3ea4807de7b2c5c903380ba2c2e7150bee942f42 [PATCH] powerpc/8xx: last two 8MB D-TLB entries are incorrectly set
c51e078f82096a7d35ac8ec2416272e843a0e1c4 [PATCH] ppc32/8xx: Fix r3 trashing due to 8MB TLB page instantiation

Thanks,
Jochen
