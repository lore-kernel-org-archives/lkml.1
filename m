Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbZFKJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbZFKJct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZFKJcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:32:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53585 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZFKJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:32:41 -0400
Date: Thu, 11 Jun 2009 10:32:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611093242.GB26509@sirena.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:24:42PM -0700, Brian Swetland wrote:

> The msm7k unfortunately requires a lot of infrastructure to work given
> that the baseband (a black box to us) controls much of the world.
> Last time around when I tried submitting some of the core ipc support
> to talk to it on the lakml, there seemed to be uncertainty about who
> even would review that.

Perhaps you might find common cause with the OMAP guys?  They've got
similar issues to resolve with things like the DSPs on OMAPs.

> We have full support for MSM7201A, including fully functional power
> management, working on a number of commercially shipping devices that
> we'd absolutely love to get into mainline.  Rebasing and bringing this
> stuff forward all the time is a lot of work and certainly not the
> optimal way to do it.  Getting it in a couple pieces at a time is slow
> going, but it seemed to cause frustration with just the small number
> of things we were looking for review/approval for...

Is there more driver stuff which you could get upstream?  I'd have
expected that it should be easier to get drivers in than the more
invasive changes like wakelocks.
