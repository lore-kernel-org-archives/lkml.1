Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYANHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYANHfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 02:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYANHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:35:04 -0500
Received: from mail.hevs.ch ([153.109.23.15]:34276 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYANHfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:35:03 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [RFC, PATCH] watchdog on gpio
Date: Mon, 14 Jan 2008 08:34:53 +0100
User-Agent: KMail/1.9.7
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
References: <200801101611.08867.marc.pignat@hevs.ch> <200801111740.25754.florian.fainelli@telecomint.eu>
In-Reply-To: <200801111740.25754.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801140834.54280.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Florian Fainelli wrote:
> Hello Marc,
> 
> Your patch looks good to me, and I have been waiting for something like 
> this :). Other comments below.
> 
> Le jeudi 10 janvier 2008, Marc Pignat a écrit :
> > +#include <asm/uaccess.h>
> > +#include <asm/arch/gpio.h>
> 
> At first sight, this will only work with the platforms which have implemented 
> gpiolib, some (like MIPS) still use the old generic GPIO API. So I think the 
> include will not work here for anything than ARM, correct me if I am wrong.
find arch -name "Kconfig" -exec grep -q "GENERIC_GPIO" {} \; -print
arch/arm/Kconfig
arch/mips/Kconfig
arch/avr32/Kconfig
arch/blackfin/Kconfig

It seems that no only arm are using GENERIC_GPIO, even some mips chips.
I probably missed wirting the subject right, should be "watchdog on GENERIC_GPIO" :)

...
> 
> Did you look into hooking into Wim's uniform watchdog driver :
> 
> http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=commit;h=732c54027e6c866f98857c4a6d1c6c466459dcd5
Now yes, interesting!

Regards

Marc

