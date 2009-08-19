Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZHSTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZHSTNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZHSTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:13:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:37867 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZHSTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:13:24 -0400
Date: Wed, 19 Aug 2009 15:13:19 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090819151319.3b82bb0a@mycelium.queued.net>
In-Reply-To: <20090818175314.16c81ca4@mycelium.queued.net>
References: <20090818175314.16c81ca4@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

BTW, this patch series includes fixes for symbol build errors (it
should fix all build issues that I'm aware of), and Tobias's changes.
When you get the chance, can you please include it in your tree so it
can get some testing?  Thanks!


On Tue, 18 Aug 2009 17:53:14 -0400
Andres Salomon <dilinger@collabora.co.uk> wrote:

> 
> This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip
> backend (allowing GPIO users to use the generic GPIO API if desired)
> while also allowing architecture-specific users directly (via the
> cs5535_gpio_* functions).
> 
> Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a mips
> cpu), which is why this is in drivers/gpio rather than arch/x86.
> Currently, it conflicts with older geode GPIO support; once MFGPT
> support is reworked to also be more generic, the older geode code
> will be removed.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
[...]
