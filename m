Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbXFUShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbXFUShu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXFUShm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:37:42 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1379 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752433AbXFUShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:37:41 -0400
Date: Thu, 21 Jun 2007 20:38:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, LKML <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@ucw.cz>
Subject: Re: Writing a driver for a legacy serial device
Message-ID: <20070621203843.044fd19a@hyperion.delvare>
In-Reply-To: <1182437233.2782.36.camel@shinybook.infradead.org>
References: <20070619190502.05d4e0c8@hyperion.delvare>
	<d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
	<20070620105648.6d18ad66@hyperion.delvare>
	<200706202311.33326.dtor@insightbb.com>
	<20070621113358.1d65678d@hyperion.delvare>
	<1182437233.2782.36.camel@shinybook.infradead.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 21 Jun 2007 22:47:12 +0800, David Woodhouse wrote:
> On Thu, 2007-06-21 at 11:33 +0200, Jean Delvare wrote:
> > OK. This leads me to a question: is it OK for me to add support for my
> > non-input device to inputattach, or is a separate, dedicated helper
> > tool preferred? Both ways are fine with me, I don't know what the
> > input subsystem maintainers expect.
> 
> You might do better to implement it as a line discipline instead. 
> Or just do it in userspace. What exactly are you trying to do?

I am writing a driver for a TAOS evaluation module. This device is a
limited SMBus master, connecting to the serial port. The evaluation
chip is connected to the SMBus. In my case this is a TSL2550 light
sensor, but virtually all compatible TAOS evaluation modules could be
supported.

I2C bus drivers have to be implemented in the kernel, so user-space
isn't an option for me.

I just posted a first (working) version of my driver, if you want to
take a look:
http://lists.lm-sensors.org/pipermail/i2c/2007-June/001508.html

Thanks,
-- 
Jean Delvare
