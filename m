Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbZBXUIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbZBXUIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbZBXUHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:07:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbZBXUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:07:51 -0500
Date: Tue, 24 Feb 2009 12:06:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, katzj@redhat.com,
       cjb@laptop.org, jayakumar.alsa@gmail.com, jordan@cosmicpenguin.net,
       linux-geode@lists.infradead.org, perex@perex.cz,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/2] cs553x-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-Id: <20090224120637.18073f93.akpm@linux-foundation.org>
In-Reply-To: <20090220221202.667fbb79@ephemeral>
References: <20090220221202.667fbb79@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 22:12:02 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip backend
> (allowing GPIO users to use the generic GPIO API if desired) while also
> allowing architecture-specific users directly (via the cs553x_gpio_*
> functions).
> 
> Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a mips
> cpu), which is why this is in drivers/gpio rather than arch/x86.  Currently,
> it conflicts with older geode GPIO support; once MFGPT support is reworked
> to also be more generic, the older geode code will be removed.
> 
> +EXPORT_SYMBOL_GPL(cs553x_gpio_set);
> +EXPORT_SYMBOL_GPL(cs553x_gpio_clear);
> +EXPORT_SYMBOL_GPL(cs553x_gpio_isset);

Nothing uses these exports.  In fact these symbols could be made static
to drivers/gpio/cs553x-gpio.c?
