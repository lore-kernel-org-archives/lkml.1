Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZGDPhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZGDPhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 11:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZGDPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 11:37:26 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36449 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZGDPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 11:37:24 -0400
Date: Sun, 5 Jul 2009 00:37:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC PATCH] linker script: unify usage of discard definition
Message-ID: <20090704153717.GA9933@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>, Tejun Heo <tj@kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
	Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>
References: <4A4E9638.20304@kernel.org> <8bd0f97a0907032251p753527e1oac25ea1740a1bfdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0907032251p753527e1oac25ea1740a1bfdb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 04, 2009 at 01:51:04AM -0400, Mike Frysinger wrote:
> On Fri, Jul 3, 2009 at 19:37, Tejun Heo wrote:
> > +/*
> > + * DISCARDS must be the last and archs which want some of the default
> > + * discarded sections in the kernel image can do so by putting them in
> > + * earlier section definition.
> > + */
> 
> i would add to the comment that some people want to discard exit
> text/data at runtime rather than link time due to cross-section
> references such as alt instructions, bug table, eh_frame, etc...
> 
> otherwise, looks good to me.  thanks !
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Agreed, as this was a source of confusion initially it is certainly worth
documenting the next time someone is scratching their head thinking about
the variations ;-)

Acked-by: Paul Mundt <lethal@linux-sh.org>
