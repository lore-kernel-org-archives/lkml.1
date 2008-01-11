Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbYAKQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbYAKQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYAKQFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:05:39 -0500
Received: from mail0.scram.de ([78.47.204.202]:39644 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760332AbYAKQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:05:38 -0500
X-Spam-Score: -4.177
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <478793BF.4070709@scram.de>
Date: Fri, 11 Jan 2008 17:05:19 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 0/5] Version 17,	series to add device tree naming
 to i2c
References: <20071220044136.20091.70984.stgit@terra.home>	<20080111095638.775670ed@hyperion.delvare> <9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
In-Reply-To: <9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

>>> The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing.

>> Now that I have read all the previous versions of this patch series
>> and, more importantly, all objections that were raised on the way, I
>> can start reviewing the latest iteration of your patches. I'll also do
>> some testing, although I have no powerpc stuff here, but at least I
>> want to make sure that there are no regressions introduced by your
>> patches on x86.

> Various people were worried about x86. Around version 15 I altered the
> patches so that they only impacted PowerPC. If they impact x86 in
> current form that is a bug.

I can only second this. The latest version of i2c-cpm
(http://patchwork.ozlabs.org/linuxppc/patch?person=1023&id=15902) makes
use of this patch, as well. On the dbox2, loading and unloading of
modules in any order just works fine.

Thanks,
Jochen

