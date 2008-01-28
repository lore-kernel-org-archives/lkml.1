Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYA1Sqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYA1Sqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYA1SqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:46:20 -0500
Received: from mail0.scram.de ([78.47.204.202]:38938 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815AbYA1SqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:46:18 -0500
X-Spam-Score: -4.228
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <479E22E0.9010105@scram.de>
Date: Mon, 28 Jan 2008 19:45:52 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Scott Wood <scottwood@freescale.com>, Jean Delvare <khali@linux-fr.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>
Subject: Re: [PATCHv3 2.6.25] i2c: adds support for i2c bus on Freescale CPM1/CPM2
 controllers
References: <479A185D.6010406@scram.de> <386072610801280921q3e96bfc1v40ad09660c0f7ad8@mail.gmail.com>
In-Reply-To: <386072610801280921q3e96bfc1v40ad09660c0f7ad8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

>> +
>> +       /* register new adapter to i2c module... */
>> +
>> +       result = i2c_add_adapter(&cpm->adap);
> 
> As I was pointed before, please use the new style i2c driver interface:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=991dee591a99d035796a8c194eb1796cc020e142

AFAIK, the device tree currently doesn't provide an adapter id. If we're going to add this property, this would be
needed on other of_platform i2c drivers, as well.

Thanks,
Jochen
