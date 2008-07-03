Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYGCAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYGCAF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGCAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:05:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYGCAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:05:18 -0400
Date: Wed, 2 Jul 2008 17:04:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net
Subject: Re: [PATCH] gpiolib: Allow user-selection
Message-Id: <20080702170431.56d4c929.akpm@linux-foundation.org>
In-Reply-To: <200807022346.53222.mb@bu3sch.de>
References: <200807022346.53222.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 23:46:53 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This patch adds functionality to the gpio-lib subsystem to
> make it possible to enable the gpio-lib code even if the
> architecture code didn't request to get it built in.

drivers/gpio/gpiolib.c: In function 'gpio_export':
drivers/gpio/gpiolib.c:432: error: 'struct class' has no member named 'devices'
drivers/gpio/gpiolib.c:456: error: implicit declaration of function 'device_create'
drivers/gpio/gpiolib.c:457: warning: assignment makes pointer from integer without a cast
drivers/gpio/gpiolib.c: In function 'gpio_unexport':
drivers/gpio/gpiolib.c:509: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
drivers/gpio/gpiolib.c:509: error: too few arguments to function 'class_find_device'
drivers/gpio/gpiolib.c: In function 'gpiochip_export':
drivers/gpio/gpiolib.c:536: error: 'struct class' has no member named 'devices'
drivers/gpio/gpiolib.c:542: warning: assignment makes pointer from integer without a cast
drivers/gpio/gpiolib.c: In function 'gpiochip_unexport':
drivers/gpio/gpiolib.c:575: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
drivers/gpio/gpiolib.c:575: error: too few arguments to function 'class_find_device'

I assume this patch was prepared against some ancient out-of-date
kernel such as current Linus mainline.

Guys, we have a new development tree now.
