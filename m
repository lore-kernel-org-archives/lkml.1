Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYFISHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYFISHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFISHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:07:23 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4843 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYFISHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:07:22 -0400
Date: Mon, 9 Jun 2008 20:06:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
In-Reply-To: <20080528201612.d2641dc3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806091950360.6791@localhost.localdomain>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
 <20080528201612.d2641dc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 28 May 2008, Andrew Morton wrote:

> >  I am not sure who actually claims maintenance of kernel/time/ntp.c, but
> > it looks, Thomas, you seem to be our current time overseer -- could you
> > please speak out on this change?  I'd like this change to get applied
> > somewhere reasonable -- is it -mm?
> 
> Roman does most of the NTP work afaik.  I consider Thomas's git-hrt
> tree to be the route via which NTP changes get into linux-next and
> mainline.

That function is a little misplaced, we already have a driver/rtc dir, 
where this should go in the long term and ntp.c only providing the 
trigger, that time is stable. There it would also be possible to better 
take into account any quirks needed to update the chip.

bye, Roman
