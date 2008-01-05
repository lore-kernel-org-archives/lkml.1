Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYAEP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYAEP3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYAEP3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:29:42 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:39916 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYAEP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:29:41 -0500
Date: Sat, 5 Jan 2008 18:29:04 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, Ville Syrjala <syrjala@sci.fi>
Subject: Re: 2.6.24-rc6-mm1 (build problem: gpio/W1)
Message-ID: <20080105152904.GB12982@2ka.mipt.ru>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101920.5fb60a3d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231101920.5fb60a3d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy.

Sorry for long delay.

On Mon, Dec 31, 2007 at 10:19:20AM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
>   CC      drivers/w1/masters/w1-gpio.o
> In file included from /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:19:
> include2/asm/gpio.h:4:18: error: gpio.h: No such file or directory
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c: In function 'w1_gpio_write_bit_dir':
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:26: error: implicit declaration of function 'gpio_direction_input'
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:28: error: implicit declaration of function 'gpio_direction_output'

I believe w1-gpio it has to depend on generic gpio, Ville can you
confirm that?

-- 
	Evgeniy Polyakov
