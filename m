Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXLSOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXLSOyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXLSOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:54:15 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:4054 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753098AbXLSOyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:54:15 -0500
Date: Wed, 19 Dec 2007 15:54:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI  ADS7828 A-D
Message-ID: <20071219155412.4519fb43@hyperion.delvare>
In-Reply-To: <4768340C.60208@linuxrealtime.co.uk>
References: <4754441F.1030405@linuxrealtime.co.uk>
	<20071212022550.d8d3b295.akpm@linux-foundation.org>
	<4768340C.60208@linuxrealtime.co.uk>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, Andrew,

Thanks for the review Andrew. I have some more comments, I'll reply to
the original post.

On Tue, 18 Dec 2007 20:56:44 +0000, Steve Hardy wrote:
> >> +static int ads7828_attach_adapter(struct i2c_adapter *adapter)
> >> +{
> >> +    if (!(adapter->class & I2C_CLASS_HWMON))
> >> +        return 0;
> > 
> > Can this happen?
> 
> Hmmm, this code exists in pretty much all of the other hwmon
> drivers, so I will leave it in.
> 
> I think it relates to I2C vs ISA connected devices, to avoid
> detecting something with the correct ID on the wrong bus?

Not at all ;) It relates to I2C buses being used in various devices
such as TV adapters, which do not have hardware monitoring chips and do
not like being randomly probed for I2C devices as most hardware
monitoring drivers do when you load them.

-- 
Jean Delvare
