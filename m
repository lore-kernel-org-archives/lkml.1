Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYAYK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYAYK1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYAYK1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:27:34 -0500
Received: from mail0.scram.de ([78.47.204.202]:39850 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYAYK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:27:33 -0500
X-Spam-Score: -4.258
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.1 AWL AWL: From: address is in the auto white-list
Message-ID: <4799B985.70605@scram.de>
Date: Fri, 25 Jan 2008 11:27:17 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHv3 6/7] [POWERPC] Rename commproc to cpm1 and cpm2_common.c
 to cpm2.c
References: <4798AC8B.9090400@scram.de> <F4B3DC7D-AC57-4C37-8708-5A3E73F5F97C@kernel.crashing.org>
In-Reply-To: <F4B3DC7D-AC57-4C37-8708-5A3E73F5F97C@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

>> drivers/net/fec.c                             |    8 --------
>> drivers/net/fec.h                             |    2 +-
> 
> asm-m68knommu/commproc.h ?? these are only built on coldfire.

Yes. Here I just removed dead code (commented out using #ifdef on coldfire). Apparently the driver was
used on MPC8xx before or was copied from there but never cleaned up? Maybe this should be a seperate patch?

>> drivers/serial/68360serial.c                  |    2 +-
> 
> I think this is using asm-m68knommu/commproc.h

Oops, that one slipped through :-/.

Thanks,
Jochen
