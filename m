Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYD0LGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYD0LGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYD0LGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:06:06 -0400
Received: from mail0.scram.de ([78.47.204.202]:51580 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYD0LGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:06:05 -0400
X-Spam-Score: -4.079
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <48145E7B.6040805@scram.de>
Date: Sun, 27 Apr 2008 13:07:39 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: [PATCH1/7] i2c: Add support for device alias names
References: <47FF70A7.5070002@scram.de> <20080426223815.16e38a85@hyperion.delvare>
In-Reply-To: <20080426223815.16e38a85@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

>> -	if ((err = f75375_probe(client)) < 0)
>> +	err = f75375_probe(client, NULL);
>> +	if (err < 0)
>>  		goto exit_detach;
>>  
>>  	return 0;
> 
> These coding style cleanups don't belong to this patch (if they belong
> anywhere - I don't much see the point)

I just wanted to make sure, scripts/checkpatch.pl doesn't complain.
But you're right. The coding style cleanup should have been another patch.

Thanks a lot for your efforts of getting the alias stuff in!

Jochen
