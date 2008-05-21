Return-Path: <linux-kernel-owner+w=401wt.eu-S935468AbYEUPKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468AbYEUPKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764845AbYEUPKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:10:10 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:65225 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763117AbYEUPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:10:09 -0400
Date: Wed, 21 May 2008 10:10:03 -0500
From: Scott Wood <scottwood@freescale.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, Linux I2C <i2c@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [POWERPC] Add i2c pins to dts and board setup
Message-ID: <20080521151003.GA13858@ld0162-tx32.am.freescale.net>
References: <4833FA0C.5090800@scram.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4833FA0C.5090800@scram.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:31:40PM +0200, Jochen Friedrich wrote:
> +   - linux,i2c-index : Can be used to hard code an i2c bus nummer.

s/nummer/number/

Why do we need this?

> +   - linux,i2c-class : Can be used to override the i2c class. The class is used
> +     by old style i2c device drivers to find a bus in a specific context like
> +     system management, video or sound. By default, I2C_CLASS_HWMON (1) is
> +     being used. The definition of the classes can be found in
> +     include/i2c/i2c.h

It'd be better to just convert any needed old-style drivers than add this
to the device tree.

> +   - bus-frequency : Can be used to set the i2c bus frequency. If unspecified,
> +     a default frequency of 60kHz is being used.

clock-frequency is the standard name for such things.

-Scott
