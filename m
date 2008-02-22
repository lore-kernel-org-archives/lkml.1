Return-Path: <linux-kernel-owner+w=401wt.eu-S1765570AbYBVLTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765570AbYBVLTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYBVLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:19:45 -0500
Received: from mail0.scram.de ([78.47.204.202]:48763 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbYBVLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:19:43 -0500
X-Spam-Score: -4.217
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47BEAF00.50106@scram.de>
Date: Fri, 22 Feb 2008 12:16:16 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale CPM1/CPM2
 controllers
References: <47A1C4E9.4000003@scram.de> <20080221130520.12b01553@hyperion.delvare>
In-Reply-To: <20080221130520.12b01553@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

>> +/*
>> + * Wait for patch from Jon Smirl
>> + * #include "powerpc-common.h"
>> + */
> 
> It doesn't make sense to merge this comment upstream.

I know you don't like the patch from Jon Smirl and you also explained your reasons.
Fortunately, I2c no longer uses numeric device IDs but names. So what are the alternatives?

1. modify the I2c subsystem to accept OF names additionally to I2c names (proposed by Jon smirl).
2. record the I2c name in the dts tree, either as seperate tag (like linux,i2c-name="<i2c-name>")
   or as additional compatible entry (like compatible="...", "linux,<i2c-name>").
3. use a glue layer with a translation map.

What is the preferred way to do this?

Thanks,
Jochen
