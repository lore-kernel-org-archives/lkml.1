Return-Path: <linux-kernel-owner+w=401wt.eu-S935817AbYEUQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935817AbYEUQRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763059AbYEUQRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:17:19 -0400
Received: from mail0.scram.de ([78.47.204.202]:44189 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbYEUQRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:17:18 -0400
X-Spam-Score: -4.216
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <48344B02.7070308@scram.de>
Date: Wed, 21 May 2008 18:17:06 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, Linux I2C <i2c@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [POWERPC] Add i2c pins to dts and board setup
References: <4833FA0C.5090800@scram.de> <20080521151003.GA13858@ld0162-tx32.am.freescale.net>
In-Reply-To: <20080521151003.GA13858@ld0162-tx32.am.freescale.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

>> +   - linux,i2c-index : Can be used to hard code an i2c bus number.
>> +   - linux,i2c-class : Can be used to override the i2c class.
>
> Why do we need this?

There are still a bunch of i2c drivers using the old API (mainly v4l and dvb stuff)
which are slowly being converted by their subsystem maintainers, though.

> It'd be better to just convert any needed old-style drivers than add this
> to the device tree.

Sure. That's why the parameters are only optional. Once all i2c drivers are
converted, these parameters won't be used anymore. Maybe they should be marked
as deprecated.

>> +   - bus-frequency : Can be used to set the i2c bus frequency. If unspecified,
>> +     a default frequency of 60kHz is being used.
> 
> clock-frequency is the standard name for such things.

I was just confused by the fact that unlike a serial port, i2c is a bus itself.

Thanks,
Jochen
