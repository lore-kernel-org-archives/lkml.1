Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbXBRRQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbXBRRQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXBRRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:16:09 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:59009 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbXBRRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:16:08 -0500
Date: Sun, 18 Feb 2007 18:16:00 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Kumar Gala <galak@kernel.crashing.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kbuild question
In-Reply-To: <9AF725F4-FE65-4357-B7EB-CC03808C105D@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0702181811220.14457@scrub.home>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
 <Pine.LNX.4.64.0702161121540.14458@scrub.home>
 <9AF725F4-FE65-4357-B7EB-CC03808C105D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 16 Feb 2007, Kumar Gala wrote:

> > Could you please be more specific about the problem you're trying to
> > solve, instead of how you're trying to solve it?
> > A real example would help a lot to understand the actual problem.
> 
> Sure, on powerpc for some of the embedded sub-architectures you can only
> select a single board to build for.  For a lot of people this is sufficient,
> however we are moving towards a world where you can easily build in support
> for multiple boards into a single kernel.
> 
> I'd like to have it such that if I'm only building support for one board
> (CONFIG_ONLY_HAVE_ONE, not going to call it that, but for this discussion its
> sufficient), you get a choice menu from Kconfig enforcing the ability to only
> select one board.  However if !CONFIG_ONLY_HAVE_ONE than you can select
> multiple boards to build into your kernel.
> 
> if CONFIG_ONLY_HAVE_ONE is set we can optimize out the runtime checks that get
> added for handling the multiple board case.

On m68k we have the same problem, but what I'm what I'm considering is to 
add a new mode for choice groups - at least one must be selected and 
kconfig generates the extra information if only one is selected.

bye, Roman
