Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXCLPaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXCLPaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030427AbXCLPaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:30:52 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52132 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030432AbXCLPav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:30:51 -0400
Date: Mon, 12 Mar 2007 16:30:33 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: bryan.wu@analog.com, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070312163033.134c351e@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070312161109.749c6d69.khali@linux-fr.org>
References: <200703091345.44744.david-b@pacbell.net>
	<11735324081261-git-send-email-hskinnemoen@atmel.com>
	<1173694079.6638.13.camel@roc-desktop>
	<20070312153457.60dafa0c@dhcp-252-105.norway.atmel.com>
	<20070312155359.39020c80@dhcp-252-105.norway.atmel.com>
	<20070312161109.749c6d69.khali@linux-fr.org>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 16:11:09 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> > By the way, timeout seems to be hardcoded to 100 jiffies in the
> > i2c-algo-bit driver, so there's probably not much point passing it from
> > the board code when it's going to be overridden anyway. I'll add just a
> > udelay parameter to the platform struct for  now.  
> 
> No, it's not hardcoded. I know it looks confusing. struct i2c_adapter
> has a timeout field, that's the one being set to 100 in i2c-algo-bit,
> but i2c-algo-bit uses the i2c_algo_bit_data timeout field. The
> i2c_adapter timeout field is unused.

Ah, I see. Now that you mention it, I seem to recall I came to that
conclusion last time I looked at the code, but I've apparently forgotten
it since then ;)

I'll add a timeout field to the platform struct as well, then.

Haavard
