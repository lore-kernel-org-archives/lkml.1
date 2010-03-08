Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0CHNcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:32:24 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751767Ab0CHNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:32:22 -0500
Date: Mon, 8 Mar 2010 14:32:21 +0100
From: Cyril Hrubis <metan@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: bit errors on spitz
Message-ID: <20100308133221.GB14904@atrey.karlin.mff.cuni.cz>
References: <20100305212708.GC21773@elf.ucw.cz> <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com> <20100308072858.GA29939@atrey.karlin.mff.cuni.cz> <20100308082530.GA1982@atrey.karlin.mff.cuni.cz> <1268048916.6477.9.camel@utx.utx.cz> <20100308121634.GA14904@atrey.karlin.mff.cuni.cz> <20100308124248.GB12363@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308124248.GB12363@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Is this display rotated by 90 degrees?

Yes it is.

> If so, they're actually horizontal lines as far as the display scanning
> is concerned - and that tends to suggest that there's insufficient system
> bus bandwidth for all the activity taking place, and the LCD controller
> is being starved of data.

Well, when doing 'echo 0 > /sys/class/graphics/fbcon/rotate_all' for 2.6.33
I've got the same problem but the lines are vertical. However 2.6.24 seems to
work in non rotated mode.

> I've seen similar (described) effects on SA1110 systems in past years
> with low clock rates.
> 
> Some of the reports suggest that this happens with multiple kernel versions
> and is not something new to the latest kernels.  Please confirm when the
> problem started.

As far as I can test in rotated mode it happens for kernels from 2.6.24 to
2.6.33 (I haven't older kernel than 2.6.24 that boots on spitz). 

-- 
metan
