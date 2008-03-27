Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYC0I0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYC0I0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYC0I0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:26:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20799 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbYC0I0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:26:35 -0400
Date: Thu, 27 Mar 2008 09:26:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Dave Airlie <airlied@gmail.com>,
       I2C <i2c@lm-sensors.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080327092617.2ab088ff@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0803261832200.16692@shell4.speakeasy.net>
References: <20080325200714.GA25487@deepthought>
	<20080326161934.7eae544f@hyperion.delvare>
	<20080326173701.GA16882@deepthought>
	<20080326201031.7c2cefb2@hyperion.delvare>
	<Pine.LNX.4.58.0803261832200.16692@shell4.speakeasy.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 18:35:10 -0700 (PDT), Trent Piepho wrote:
> On Wed, 26 Mar 2008, Jean Delvare wrote:
> > Totally unrelated, but FYI: the chip at 0x50 is an EDID EEPROM in your
> > display (which the radeonfb driver can use to switch to the correct
> > resolution / refresh rate.)
> [...]
> > any of these chips. So, the mysterious effect of unloading the
> > i2c-viapro driver can't be explained by an i2c chip driver detaching
> > from its device. So, again, I really can't see how i2c can be involved
> > in your problem.
> 
> Maybe the radeonfb driver is trying to talk to EDID EEPROMs on all I2C
> adapters it finds?  When it tries to using the i2c-viapro adapter, it
> hangs.

No, the radeonfb driver only probes for EEPROMs on (at most) its 4 own
I2C buses. It doesn't even know about the other I2C buses on the system.

Note that I am using radeonfb and i2c-viapro myself, so if there was a
conflict between both drivers, I think would know by now. I've not
experienced the problem reported by Ken. But I don't use gdm.

Note that I am using the X.org radeon driver. Ken did not tell which X
driver he was using, maybe it matters.

-- 
Jean Delvare
