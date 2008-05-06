Return-Path: <linux-kernel-owner+w=401wt.eu-S1765141AbYEFSj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765141AbYEFSj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYEFSjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:39:46 -0400
Received: from mail0.scram.de ([78.47.204.202]:47516 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbYEFSjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:39:44 -0400
X-Spam-Score: -4.082
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <4820A5E9.8030204@scram.de>
Date: Tue, 06 May 2008 20:39:37 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Kumar Gala <galak@kernel.crashing.org>, Jean Delvare <khali@linux-fr.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] [POWERPC] Fix of_i2c include for module compilation
References: <481C5DD0.5090503@scram.de> <18462.35282.374180.770237@cargo.ozlabs.ibm.com>
In-Reply-To: <18462.35282.374180.770237@cargo.ozlabs.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

>> -#ifdef CONFIG_OF_I2C
>> +#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
>>  
>>  void of_register_i2c_devices(struct i2c_adapter *adap,
>>  			     struct device_node *adap_node);
> 
> Why do we have that ifdef there at all?  There's only that one
> external declaration within it, so the #ifdef and #endif could just be
> removed.  If the ifdef hadn't been there in the first place we
> wouldn't have had this problem.

You're right. I mainly copied from of_gpio.h without too much thinking :(.
I'll resend.

Thanks,
Jochen
