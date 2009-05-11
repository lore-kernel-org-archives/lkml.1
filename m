Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZEKL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZEKL2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZEKL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:28:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46672 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZEKL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:28:04 -0400
Date: Mon, 11 May 2009 12:28:01 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: ???? <wxc200@gmail.com>, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error
	report
Message-ID: <20090511112801.GA20283@sirena.org.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> <20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk> <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com> <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk>
X-Cookie: Life is like a simile.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:31:51AM +0100, Michael Abbott wrote:

> static struct i2c_pxa_platform_data xcep_i2c_platform_data  = {
>         .class = I2C_CLASS_HWMON
> };

> ...
>         pxa_set_i2c_info(&xcep_i2c_platform_data);

> This is called in the .init_machine method, and the target system is a 
> PXA255.

> However, after the error messages on startup, all the sensors seem to be 
> detected and seem to be operating normally.

These errors occur when attempting to talk to non-existant devices which
is almost certainly going to happen with the class based device probing
since the kernel will probe for each device at each possible address on
each I2C bus.
