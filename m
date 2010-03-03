Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0CCWCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:02:38 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61867 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0CCWCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:02:32 -0500
Date: Wed, 3 Mar 2010 23:02:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303230229.77df3ac3@hyperion.delvare>
In-Reply-To: <4B8EB99F.4080104@jic23.retrosnub.co.uk>
References: <4B8C1867.7040201@cam.ac.uk>
	<404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	<alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	<20100303184132.GA11471@core.coreip.homeip.net>
	<alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	<20100303190753.GB11471@core.coreip.homeip.net>
	<4B8EB99F.4080104@jic23.retrosnub.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan, all,

On Wed, 03 Mar 2010 19:33:51 +0000, Jonathan Cameron wrote:
> I certainly have no objection to taking light sensors back into IIO.
> (one never moved out!)  Obviously I'll want opinions from the individual
> driver developers before doing this. As things currently stand it involves
> moving drivers out of mainline into staging. Whilst we have numerous drivers
> being developed against the subsystem as is, elements of it (including the
> userspace api) are still changing.

Honestly, I don't care. The light sensor drivers can live wherever you
want and use whatever interface you want, I don't give a damn. What I
really want is that:
1* All light sensor drivers live at the same place in the kernel tree,
   so that people looking for them know where to look.
2* drivers/i2c/chips dies. Meaning that, if the tsl2550 driver has not
   moved away from drivers/i2c/chips by rc1, I'll move it myself, manu
   militari, to drivers/misc.

I am a little sad to see two discussions about the ALS subsystem right
in the middle of the merge window, one about what the interface should
be and one about what the subsystem should include, while discussions
about these two points have been ongoing publicly for 5 months now. I
really want things (whatever they are) happen now and not in another 5
months.

-- 
Jean Delvare
