Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYECMVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYECMVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYECMV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:21:27 -0400
Received: from mail0.scram.de ([78.47.204.202]:39906 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYECMV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:21:26 -0400
X-Spam-Score: -4.077
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <481C58C0.4040107@scram.de>
Date: Sat, 03 May 2008 14:21:20 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] [PATCH] modpost: i2c aliases need no trailing wildcard
References: <20080502203721.70c5dc09@hyperion.delvare>
In-Reply-To: <20080502203721.70c5dc09@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Here's a patch doing this. If nobody objects, I'll send it to Linus
> through my i2c tree next week.

looks good to me:

#cat modules.alias 
# Aliases extracted from modules themselves.
alias i2c:dbox2-fp dbox2_fp
alias of:N*T*Cfsl,cpm-i2c* i2c_cpm
alias i2c:dummy i2c_core
alias i2c:saa7129 saa7127
alias i2c:saa7128 saa7127
alias i2c:saa7127 saa7127
alias i2c:saa7126 saa7127

Thanks,
Jochen
