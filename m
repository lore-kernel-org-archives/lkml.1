Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0CHMso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:48:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50089 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0CHMsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:48:40 -0500
Date: Mon, 8 Mar 2010 12:42:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: bit errors on spitz
Message-ID: <20100308124248.GB12363@n2100.arm.linux.org.uk>
References: <20100305212708.GC21773@elf.ucw.cz> <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com> <20100308072858.GA29939@atrey.karlin.mff.cuni.cz> <20100308082530.GA1982@atrey.karlin.mff.cuni.cz> <1268048916.6477.9.camel@utx.utx.cz> <20100308121634.GA14904@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308121634.GA14904@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 01:16:35PM +0100, Cyril Hrubis wrote:
> Hi!
> > - And I see display noise while CF Wi-Fi card is active.
> 
> Forgotten about this one. See for yourself, notice short black vertical lines
> flashing randomly.

I haven't looked at the video.

Is this display rotated by 90 degrees?

If so, they're actually horizontal lines as far as the display scanning
is concerned - and that tends to suggest that there's insufficient system
bus bandwidth for all the activity taking place, and the LCD controller
is being starved of data.

I've seen similar (described) effects on SA1110 systems in past years
with low clock rates.

Some of the reports suggest that this happens with multiple kernel versions
and is not something new to the latest kernels.  Please confirm when the
problem started.
