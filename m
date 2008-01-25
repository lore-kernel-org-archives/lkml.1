Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYAYQFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYAYQFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYAYQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:05:10 -0500
Received: from mail0.scram.de ([78.47.204.202]:54276 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbYAYQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:05:07 -0500
X-Spam-Score: -2.359
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  2.7 TVD_SUBJ_WIPE_DEBT TVD_SUBJ_WIPE_DEBT
 *  1.1 SORTED_RECIPS Recipient list is sorted by address
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 * -1.7 AWL AWL: From: address is in the auto white-list
Message-ID: <479A087F.5010305@scram.de>
Date: Fri, 25 Jan 2008 17:04:15 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: galak@kernel.crashing.org, geert@linux-m68k.org, gerg@uclinux.org,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, scottwood@freescale.com,
       vitb@kernel.crashing.org
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
References: <4799F349.9090102@scram.de> <E1JIQpQ-0006Xj-RR@faramir.fjphome.nl>
In-Reply-To: <E1JIQpQ-0006Xj-RR@faramir.fjphome.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

> Jochen Friedrich wrote:
>> +++ b/drivers/net/fec.c
>> @@ -23,6 +23,9 @@
>>   *
>>   * Bug fixes and cleanup by Philippe De Muyter (phdm@macqel.be)
>>   * Copyright (c) 2004-2006 Macq Electronique SA.
>> + *
>> + * This driver is now only used on ColdFire processors. Remove conditional
>> + * Powerpc code. 
>>   */
> 
> This comment makes sense for a changelog, but IMO it makes no sense at all
> to add it to the file.

I just added it to clarify this code is now only used on m68knommu (Coldfire).
The comments on top are mailny about MPC860T CPUs (PowerPC), however the driver is no
longer used for these CPUs.

Maybe the wording should be changed to:

This driver is now only used on ColdFire (m68knommu) processors. Conditional
PowerPC code has been removed.

Thanks,
Jochen
