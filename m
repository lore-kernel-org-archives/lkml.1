Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0BDVRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:17:41 -0500
Received: from smtp103.biz.mail.mud.yahoo.com ([68.142.200.238]:49113 "HELO
	smtp103.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757865Ab0BDVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:17:40 -0500
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: 7rqAYTsVM1lK8V7.O7ZfYPUQ8.akbM8wF1dVYYp9dVvGsCFgAWvqEl1V6zuZsu7Ge09sXB4BpOxRCPkKLcogHgIiQK1HTpW.x472IMgl5kRCkS5GzMyJcjcrOUokgZvmdzYA5L84DpZv5To0alSyAbFc1VSnOK_Cxhr0vnsE0koURkHF.Rm.t9hTP.OfJ2qyUcIOzr5sverU5jc..YQLfm7XCP2PWVElXl8UY8KevWQdxW_b8NXy9AV8jcYCwYJU36RbUz.Xs5rNdMPcisEWhBvsjv3i.awRqsiuyEJp1DiAzqTah0bAKYnZN2Ti5gYw5qiVy72UlFE6wAdbZpb0ABjN7CdE0ap2DCmODa4rZ8ASlIK0rv9xj8V.XMA81aPbAaF0n8c59Q--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hwmon: driver for TI tmp102 temperature sensor
Date: Thu, 4 Feb 2010 13:17:37 -0800
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <201002031723.49976.sfking@fdwdc.com> <20100204102203.ecf4bbb5.akpm@linux-foundation.org>
In-Reply-To: <20100204102203.ecf4bbb5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002041317.37574.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 10:22:03 Andrew Morton wrote:
> On Wed, 3 Feb 2010 17:23:49 -0800
>
> Steven King <sfking@fdwdc.com> wrote:
> > The TI TMP102 is similar to the lm75.  It differs from the lm75 by having
> > a 16 bit conf register and the temp registers have a minimum resolution
> > of 12bits; the extended conf register can select 13 bit resolution (which
> > this driver does) and also change the update rate (which this driver
> > currently doesn't use).
>
> A neat little driver.

Thanks.

> checkpatch spits this warning:
>
>     WARNING: struct dev_pm_ops should normally be const
>     #387: FILE: drivers/hwmon/tmp102.c:300:
>     +static struct dev_pm_ops tmp102_dev_pm_ops = {
>
> which seems truthful enough.

Indeed.   I am, however, somewhat surprised since I ran the patch thru 
checkpatch before posting it and no errors or warnings were reported.  Is 
there a version of checkpatch other than the one included in the tree that I 
should be using?

>
> And doing this will hurt readers' brains less:
>
>
>
> Use conventional array-walk loop.

Ah yes, an idiosyncrasy of mine in preferring do while over for loops 
especially when I 'know' the initial test will pass.  Whatever is the 
preferred idiom for the kernel is fine with me.

-- 
Steven King -- sfking at fdwdc dot com
