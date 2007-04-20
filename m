Return-Path: <linux-kernel-owner+w=401wt.eu-S1767168AbXDTRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767168AbXDTRtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993301AbXDTRtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:49:23 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2882 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993299AbXDTRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:49:22 -0400
Date: Fri, 20 Apr 2007 19:49:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070420194933.0813a359@hyperion.delvare>
In-Reply-To: <20070419205942.GC5577@csclub.uwaterloo.ca>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
	<20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
	<20070414192807.60bdf84b@hyperion.delvare>
	<20070418174256.GB5577@csclub.uwaterloo.ca>
	<20070419085413.1520feef@hyperion.delvare>
	<20070419205942.GC5577@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

On Thu, 19 Apr 2007 16:59:42 -0400, Lennart Sorensen wrote:
> On Thu, Apr 19, 2007 at 08:54:13AM +0200, Jean Delvare wrote:
> > The major difference is that the implementation in scx200_i2c is
> > hardware-specific, while the i2c-gpio driver is a generic one, so it's
> > a lot better.
> > 
> > What this means is that i2c-gpio obsoletes scx200_i2c, so I am inclined
> > to delete scx200_i2c right away. I'm not even sure anyone still uses it
> > now that scx200_acb has been fixed and is reported to work very well.
> > If anyone really needs to do I2C over GPIO pins on SCx200, this should
> > be reimplemented on top of i2c-gpio.
> 
> I use scx200_i2c.  The SBC I am using doesn't work with the scx200_acb
> (different pins on the cpu after all).  I would love to see it
> reimplemented using the generic interface, since there isn't that many
> lines of code involved as far as I can tell.  Well scx200_acb works fine
> on a Geode LX board, but not on a Geode SC1200 board.  Unless it has
> been fixed since 2.6.18, then it still doesn't work, but scx200_i2c
> works perfectly fine.

The scx200_acb driver was heavily modified in 2.6.17 and 2.6.18, not
much since then. I am not familiar with the hardware so I can't comment
on which chips are supposed to work and which aren't.

-- 
Jean Delvare
