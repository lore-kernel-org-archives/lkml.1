Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0CHIZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:25:36 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50088 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750950Ab0CHIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:25:32 -0500
Date: Mon, 8 Mar 2010 09:25:30 +0100
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Subject: Re: bit errors on spitz
Message-ID: <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
References: <20100305212708.GC21773@elf.ucw.cz> <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com> <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> dmesg would not be useful, it usually hits user programs. Like... mutt
> suddenly displaying , instead of - in the header. Program failing to
> start because function printg is not found (it was not exactly
> printf->printg,  I don't remember exact symbol), ping complaining
> about discarding corrupted packets, etc.
> 
> (Or of course, kernel oopsing or not going from suspend at all. But as
> even user data are being corrupted, oops is not likely to be
> interesting and system is typically not in state to capture it any more.)
>

Well I've seen empty lines when editing file with vim (these that are starting
with blue tilda) in the middle of file. And sometimes programs segfaults for no
good reason. Just today I've run "apt-get update" and got:

symbol lookup error: apt-get: undefined symbol: _ZN16pkgAcquireStatus4StopEv

While the correct symbol seems to be _ZN16pkgAcquireStatus4.

When running 'make' in kernel directory and closing the display sometimes
machine dies and nothing but reset under battery cover helps. I remeber waking
up in the morning, opening the device and reseting the device. And it seems to
be provoked much more by active CF wifi card.

-- 
metan
