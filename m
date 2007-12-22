Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbXLVJ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbXLVJ6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXLVJ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:58:29 -0500
Received: from mail0.scram.de ([78.47.204.202]:56137 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXLVJ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:58:28 -0500
X-Spam-Score: -3.944
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <476CDFEC.1070506@scram.de>
Date: Sat, 22 Dec 2007 10:59:08 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH POWERPC] i2c: adds support for i2c bus on Frescale CPM1/CPM2
 controllers
References: <476C15BC.3090807@scram.de> <20071222001112.691b80c8@kernel.crashing.org>
In-Reply-To: <20071222001112.691b80c8@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> I had an attempt a while ago to do this but haven't had enough time to get it completed, so
> I am glad to see it finally picked up. There was some sort of discussion that time, you seem to have some of those points
> addressed but  something not, please
> check: http://lkml.org/lkml/2007/5/8/45
>
> (for instance, cpm_i2c_shutdown() and i2c_cpm_del_bus() are void because they cant' fail)
>   

I'll resend a fixed patch.

> Also, why this was directed to Scott? This is lm-sensors stuff and is
> Jean Delvare <khali@linux-fr.org> material..

Scott reviewed this driver last time and i hope to get some further 
comments from him. But thanks for adding
Jean as well.

Thanks,
Jochen

