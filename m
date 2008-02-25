Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYBYSft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYBYSft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYBYSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:35:40 -0500
Received: from mail0.scram.de ([78.47.204.202]:43892 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbYBYSfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:35:39 -0500
X-Spam-Score: -4.217
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47C2F15B.8070703@scram.de>
Date: Mon, 25 Feb 2008 17:48:27 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale	CPM1/CPM2
 controllers
References: <47A1C4E9.4000003@scram.de> <20080221130520.12b01553@hyperion.delvare> <47BEAF00.50106@scram.de> <20080223212823.GA22131@lixom.net> <47C18A4E.5080804@scram.de> <20080224181509.GA6745@lixom.net>
In-Reply-To: <20080224181509.GA6745@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

> And even if you DO decide to go that route, guess what? You need a
> translation table just as with (3) anyway!

True.

>>>> 3. use a glue layer with a translation map.
>>> In my opinion this is an OK solution since the same information has to
>>> be added somewhere already anyway -- eiither to the drivers or to this
>>> translation table. It should of course be an abstacted shared table,
>>> preferrably contained under the i2c source directories since several
>>> platforms and architectures might share them.
>> I could think of a mixture between 2. and 3.:
>>
>> Using the compatible attribute with the manufacturer stripped off as I2c name by default
>> and using an exception table. For now, the struct i2c_driver_device would currently only
>> need one entry ("dallas,ds1374", "rtc-ds1374").
> 
> You still need the translation table, you're just flattening the
> namespace to one string instead of two, the same information still has
> to be encoded. I can't see what the benefit of this approach compared to
> the other one is. "dallas,ds1374" already only has one translation entry
> in the table?

As soon as http://lists.lm-sensors.org/pipermail/i2c/2008-January/002752.html has been
applied, one could get rid of all entries where the I2c (alias) name can be obtained from
the OF name just by stripping the manufacturer.

Thanks,
Jochen
