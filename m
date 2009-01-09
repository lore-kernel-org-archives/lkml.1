Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZAIXzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZAIXzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZAIXzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:55:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbZAIXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:55:34 -0500
Date: Fri, 9 Jan 2009 15:55:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: - lis3lv02d-separate-the-core-from-hp-acpi-api.patch removed
 from -mm tree
Message-Id: <20090109155528.50772d56.akpm@linux-foundation.org>
In-Reply-To: <4967DFD3.8070100@tremplin-utc.net>
References: <200901091958.n09JwbJs031498@imap1.linux-foundation.org>
	<20090109230003.GB2223@elf.ucw.cz>
	<20090109152317.ca2a2da8.akpm@linux-foundation.org>
	<4967DFD3.8070100@tremplin-utc.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 00:37:55 +0100
__ric Piel <eric.piel@tremplin-utc.net> wrote:

> Andrew Morton wrote:
> > On Sat, 10 Jan 2009 00:00:03 +0100
> > Pavel Machek <pavel@suse.cz> wrote:
> > 
> >>> The patch titled
> >>>      LIS3LV02D: separate the core from HP ACPI API
> >>> has been removed from the -mm tree.  Its filename was
> >>>      lis3lv02d-separate-the-core-from-hp-acpi-api.patch
> >>>
> >>> This patch was dropped because other changes were merged, which wrecked this patch
> >> I'm confused. The other patch collided with leds/Makefile changes, but
> >> this one applies cleanly over Linus' git (updated today)... or am I
> >> doing something wrong? Could it still be pushed to Linus?
> > 
> > umm, sure, we can try that.
> > 
> > Please don't use vague terms like "the other patch".  I assume you're
> > referring to lis3lv02d-merge-with-leds-hp-disk.patch?
> > 
> > It has more problems than a simple makefile conflict.  People keep on
> > changing stuff in linux-next.  
> I'm also confused because from your "-mm merge plans" mail I had
> understood that both patches would be merged in 2.6.29, and they both
> still apply fine on Linus' tree. How come it's a problem they conflicts
> in linux-next? Is it because this is currently the merge window?

yes.  linux-next is the candidate "next" tree, and I base patches off
that, expecting that the git trees will merge first in an orderly
fashion.

Instead, there's an enormous amount of scrambling to shove things in at
the last second, thus screwing up much longer-established code.

I'm getting fairly fed up with this.

> Do I
> have to update the patches against linux-next and send them back to you?
> Let me know what you need :-)

Please retest and resend lis3lv02d-merge-with-leds-hp-disk.patch.  If that's
the patch we're talking about here.

That will result in trashing the panding changes to
drivers/leds/leds-hp-disk.c in linux-next, but hey, at least I get to
poop in someone else's bed for once.

