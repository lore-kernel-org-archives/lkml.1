Return-Path: <linux-kernel-owner+w=401wt.eu-S965982AbXDBV7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982AbXDBV7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965983AbXDBV7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:59:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3634 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965982AbXDBV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:59:14 -0400
Date: Mon, 2 Apr 2007 22:59:00 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [patch 2.6.21-rc5-git 2/2] update Documentation/driver-model/platform.txt
Message-ID: <20070402215900.GA22728@flint.arm.linux.org.uk>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Andres Salomon <dilinger@debian.org>
References: <200703311458.43800.david-b@pacbell.net> <d120d5000704021316o7e30d51ej3f4a749ce5a49b5a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000704021316o7e30d51ej3f4a749ce5a49b5a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 04:16:03PM -0400, Dmitry Torokhov wrote:
> On 3/31/07, David Brownell <david-b@pacbell.net> wrote:
> >+A better solution is usually:
> >+
> >+       struct platform_device *platform_device_register_simple(
> >+                       char *name, unsigned id,
> >+                       struct resource *res, unsigned nres);
> >+
> >+You can use platform_device_register_simple() as a one-step call to 
> >allocate
> >+and register a device.
> 
> DIdn't Russell want to convert eberything to platform_device_alloc and
> then nuke platfrom_device_register_simple()?

That was my long term plan - since I don't like APIs which "grow" lots
of different and redundant interfaces.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
