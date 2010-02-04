Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0BDShT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:37:19 -0500
Received: from poutre.nerim.net ([62.4.16.124]:63071 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab0BDShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:37:15 -0500
Date: Thu, 4 Feb 2010 19:37:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking@fdwdc.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: driver for TI tmp102 temperature sensor
Message-ID: <20100204193712.22e8b6e7@hyperion.delvare>
In-Reply-To: <201002031723.49976.sfking@fdwdc.com>
References: <201002031723.49976.sfking@fdwdc.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, 3 Feb 2010 17:23:49 -0800, Steven King wrote:
> The TI TMP102 is similar to the lm75.  It differs from the lm75 by having a 16 bit conf register
> and the temp registers have a minimum resolution of 12bits; the extended conf register
> can select 13 bit resolution (which this driver does) and also change the update rate (which this
> driver currently doesn't use).
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>
> ---
> 
> Driver for the TI TMP102.

Could you please send a dump of your TMP102 chip, using i2cdump in word
mode?

-- 
Jean Delvare
