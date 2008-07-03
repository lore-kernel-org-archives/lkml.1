Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYGCA04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYGCA04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYGCA0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:26:49 -0400
Received: from bu3sch.de ([62.75.166.246]:48674 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYGCA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:26:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Thu, 3 Jul 2008 02:26:17 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net
References: <200807022346.53222.mb@bu3sch.de> <20080702170431.56d4c929.akpm@linux-foundation.org>
In-Reply-To: <20080702170431.56d4c929.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030226.17675.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008 02:04:31 Andrew Morton wrote:
> On Wed, 2 Jul 2008 23:46:53 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > This patch adds functionality to the gpio-lib subsystem to
> > make it possible to enable the gpio-lib code even if the
> > architecture code didn't request to get it built in.
> 
> drivers/gpio/gpiolib.c: In function 'gpio_export':
> drivers/gpio/gpiolib.c:432: error: 'struct class' has no member named 'devices'
> drivers/gpio/gpiolib.c:456: error: implicit declaration of function 'device_create'
> drivers/gpio/gpiolib.c:457: warning: assignment makes pointer from integer without a cast
> drivers/gpio/gpiolib.c: In function 'gpio_unexport':
> drivers/gpio/gpiolib.c:509: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> drivers/gpio/gpiolib.c:509: error: too few arguments to function 'class_find_device'
> drivers/gpio/gpiolib.c: In function 'gpiochip_export':
> drivers/gpio/gpiolib.c:536: error: 'struct class' has no member named 'devices'
> drivers/gpio/gpiolib.c:542: warning: assignment makes pointer from integer without a cast
> drivers/gpio/gpiolib.c: In function 'gpiochip_unexport':
> drivers/gpio/gpiolib.c:575: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> drivers/gpio/gpiolib.c:575: error: too few arguments to function 'class_find_device'
> 
> I assume this patch was prepared against some ancient out-of-date
> kernel such as current Linus mainline.

Oh well. Let me diff it against linux-next then. I didn't know Linus'
tree doesn't get any development updates anymore in time and so is
considered "ancient".

> Guys, we have a new development tree now.

-- 
Greetings Michael.
