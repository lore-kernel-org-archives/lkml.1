Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXCBUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXCBUfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965585AbXCBUfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:35:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56614
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965565AbXCBUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:35:15 -0500
Date: Fri, 02 Mar 2007 12:35:14 -0800 (PST)
Message-Id: <20070302.123514.35465791.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: romosan@sycorax.lbl.gov, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, rpurdie@rpsys.net
Subject: Re: 2.6.21-rc2 radeon backlight
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070302122920.a2967ebf.akpm@linux-foundation.org>
References: <20070301184531.b3aeafe3.akpm@linux-foundation.org>
	<87tzx35zkc.fsf@sycorax.lbl.gov>
	<20070302122920.a2967ebf.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Mar 2007 12:29:20 -0800

> On Fri, 02 Mar 2007 09:24:03 -0800
> Alex Romosan <romosan@sycorax.lbl.gov> wrote:
> 
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > > On Wed, 28 Feb 2007 08:32:43 -0800
> > > Alex Romosan <romosan@sycorax.lbl.gov> wrote:
> > >
> > >> the backlight on my thinkpad still (2.6.20 worked fine) doesn't come
> > >> on if i have the radeon backlight enabled. without it, i guess it's
> > >> the ibm acpi modules that controls the backlight and it seems to work
> > >> fine.
> > >> 
> > >
> > > Unclear. Are you saying that the backlight comes on OK if you use
> > > the IBM acpi module?
> > 
> > yes, if i disable the radeon backlight and use the ibm acpi module,
> > than the backlight works. if i enable the radeon backlight, the screen
> > stays dark and i can't turn it on (i tried using radeontool to control
> > it but nothing happened).
> 
> Richard, is this actually a bug, or is it a config error or something like that?
> 
> And should we track it as a post-2.6.20 regression?

Why don't we compromise for 2.6.21 by marking the Radeon backlight
stuff EXPERIMENTAL until the cases where IBM ACPI works and the
Radeon backlight stuff does not are worked out?
