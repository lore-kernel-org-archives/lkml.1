Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYIEOpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYIEOpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIEOox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:44:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:41864 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYIEOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NWTzWQboQg+RCNqto9dI57w2mBFDl7scgA2iJ+s649M3VGPfQZ+hxPT0J+jeeATVN0
         IjyPmshYAyMWYocy41cHZsz/oHMteFgevluNk6xC2M5kTQDzJWziVdr396hUdyNTLUZo
         RzpC/SbeaI84IVuOV8IB64UxnL17PpZOZ9CKU=
Message-ID: <38b2ab8a0809050744u5d2c5fcfnd4a0732de70ce241@mail.gmail.com>
Date: Fri, 5 Sep 2008 16:44:47 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
In-Reply-To: <20080905154948.24d2b460@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	 <20080904103707.557ac764@hyperion.delvare>
	 <38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
	 <20080904120855.7e7b9720@hyperion.delvare>
	 <38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
	 <20080905112056.44b7b910@hyperion.delvare>
	 <38b2ab8a0809050544l1914530clec53494e12c77ff5@mail.gmail.com>
	 <20080905151157.21b7f8ce@hyperion.delvare>
	 <38b2ab8a0809050638m524feaeet51817a8207505b87@mail.gmail.com>
	 <20080905154948.24d2b460@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 3:49 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Fri, 5 Sep 2008 15:38:23 +0200, Francis Moreau wrote:
>> On Fri, Sep 5, 2008 at 3:11 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> > It's not about hacking, it can be done cleanly. Just have the adapter
>> > driver code check for information in the platform data, and if class
>> > information is provided, use that instead of the default value. Or if
>> > all users will provide the information, don't even have a default in
>> > the driver. Again, the class flags are a (needed) mechanism, the policy
>> > is left for driver authors and platform maintainers to establish.
>>
>> Ah OK I see now.
>>
>> On v2.6.23 i2c-gpio.c had no I2C_CLASS_HWMON flag set and
>> had no way to pass this info from platform board.
>>
>> But on v2.6.27 it is now set whatever the platforms.
>>
>> Wouldn't it have been better to allow the platform code to pass this type
>> information through the 'i2c_gpio_platform_data' structure for example ?
>
> If you have a need for that, sure. If you don't, that's making the code
> more complex for no good reason.
>
> I expect I2C_CLASS_HWMON to be removed from that driver soon. Now that
> almost all hwmon drivers have been converted to support instantiated
> I2C devices, and given that all users of i2c-gpio are embedded
> architectures with platform code, it should be no longer needed. But
> again I am leaving it to whoever is actually using this driver to
> decide what is best for them.
>

OK, thanks a lot for the clarifications
-- 
Francis
