Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbYARRcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbYARRcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbYARRb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:31:57 -0500
Received: from mail0.scram.de ([78.47.204.202]:47447 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760959AbYARRbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:31:55 -0500
X-Spam-Score: -4.049
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <4790E2DF.90806@scram.de>
Date: Fri, 18 Jan 2008 18:33:19 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
References: <478F4AE3.5090803@scram.de> <4790DC33.2070104@freescale.com>
In-Reply-To: <4790DC33.2070104@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood schrieb:

>> +void watchdog_poke(void)
>> +{
>> +    if (wdt) {
>> +        out_be16(&wdt->swsrr, 0x556c);
>> +        out_be16(&wdt->swsrr, 0xaa39);
>> +    }
>> +}
> 
> This should be a function pointer, to allow for other watchdog types.

Thanks for the comments. Stephen Rothwell also asked if the filename watchdog.c is too generic.
I think the pq watchdog is easy enough to keep it in the generic watchdog.c file, but the
function pointer definitely is the way to go. I'll resubmit.

Thanks,
Jochen
