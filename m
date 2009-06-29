Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZF2Ulk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZF2Ulk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF2Ulb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:41:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59492 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZF2Ulb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:41:31 -0400
Date: Mon, 29 Jun 2009 22:43:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH, v3] eeepc-laptop: Fix build failure with HOTPLUG_PCI && !SYSFS (was: [git pull request] ACPI & driver patches for 2.6.31-rc1)
Message-ID: <20090629204350.GA8253@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain> <20090629080754.GA28336@elte.hu> <20090629081016.GA31398@elte.hu> <20090629081339.GA321@elte.hu> <alpine.LFD.2.00.0906291135550.5716@localhost.localdomain> <20090629193406.GA30774@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629193406.GA30774@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:34:06PM +0200, Ingo Molnar wrote:
> 
> * Len Brown <lenb@kernel.org> wrote:
> 
> > Thanks for fixing this config, Ingo.
> > 
> > I agree, our build system can handle "depends",
> > but "select" does not deliver on what it advertises,
> > making it a trap for programmers.
> 
> Hm, this portion of Kconfig is a trap in a way indeed - on the other 
> hand it is also a useful tool and the simplistic approach to 
> disallow select altogether is a step backwards.
> 
> IIRC either Vegard or Steve has come up with a patch series that 
> improved Kconfig to warn about problem selects while still allowing 
> the simple ones. That would deflect most of the bad uses while still 
> allowing the good uses. Not sure what happened to that series.

Steve came up with a patch that warned about problematic select
only in a defconfig. It did not warn properly for all the problematic
selects.
I ran (as usual) out of time last time I looked :-(
I would likely need a full day or two to come up with somthing,
but these days finding an hour is not easy.

	Sam
