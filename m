Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYC0BmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYC0BmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYC0Blw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:41:52 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:42348 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYC0Blv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:41:51 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 21:41:51 EDT
Date: Wed, 26 Mar 2008 18:35:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Jean Delvare <khali@linux-fr.org>
cc: Ken Moffat <zarniwhoop@ntlworld.com>, Dave Airlie <airlied@gmail.com>,
       I2C <i2c@lm-sensors.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [i2c] Regression (gdm no longer shuts down) - 2.4.24.x and	2.6.25
In-Reply-To: <20080326201031.7c2cefb2@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0803261832200.16692@shell4.speakeasy.net>
References: <20080325200714.GA25487@deepthought> <20080326161934.7eae544f@hyperion.delvare>
 <20080326173701.GA16882@deepthought> <20080326201031.7c2cefb2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Jean Delvare wrote:
> Totally unrelated, but FYI: the chip at 0x50 is an EDID EEPROM in your
> display (which the radeonfb driver can use to switch to the correct
> resolution / refresh rate.)
[...]
> any of these chips. So, the mysterious effect of unloading the
> i2c-viapro driver can't be explained by an i2c chip driver detaching
> from its device. So, again, I really can't see how i2c can be involved
> in your problem.

Maybe the radeonfb driver is trying to talk to EDID EEPROMs on all I2C
adapters it finds?  When it tries to using the i2c-viapro adapter, it
hangs.
