Return-Path: <linux-kernel-owner+w=401wt.eu-S934964AbXHGQUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbXHGQUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXHGQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:20:28 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:1831 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXHGQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:20:27 -0400
Message-ID: <46B89C10.7090507@genesi-usa.com>
Date: Tue, 07 Aug 2007 17:21:36 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, Alan Curry <pacman@TheWorld.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200708020440.l724edCT290676@shell01.TheWorld.com> <46B79562.9020202@genesi-usa.com> <f4545a576abeddf00f076a0cae9e3fdd@kernel.crashing.org>
In-Reply-To: <f4545a576abeddf00f076a0cae9e3fdd@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Segher Boessenkool wrote:
> 
> That's hardly the only reason.  But yeah, that's one way to
> implement the workaround, but _we_ (the Linux community) cannot
> do it like that (easily) for all users.

But you're the guy who told us our firmware sucks and we should fix our
firmware rather than clutter Linux with too many fixups. There are about
200 lines of code required to bring the Efika device tree up to the
Linux "specification" of a 5200B device tree, which will never make it
into code. Pegasos is ostensibly the same way.

Linux is already a bad enough moving target, and none of these fixes help
other operating systems or developers, if we only patch Linux, and only
say, you must run the latest Linux kernel version, and the latest U-Boot,
and the latest FDT binary, and encourage users to upgrade it all regardless
of your worries.

So, there are two opinions here;

1) the reports as we had when Efika was released and continually levied
against Pegasos firmware, that the firmware is broken and must be fixed
to comply, and no fixes will be considered because "bplan sucks and must
fix it"

2) As long as the patches are 2 lines big, you will allow them in, because
it is too much for a user to update firmware or run a script to boot?

Would you guys rather we shipped a boot script that ran the OS, fixed
all these issues in-place in-firmware, so Linux did not have to have these
workarounds, or are you accepting patches now? Because I can write those
200 lines of code to work around Efika device tree mistakes you yourself
complained about at Christmas last year..

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
