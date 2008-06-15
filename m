Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYFORMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYFORMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 13:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbYFORL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 13:11:59 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:38264 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563AbYFORL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 13:11:59 -0400
Date: Sun, 15 Jun 2008 19:11:41 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080615171140.GG22313@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu> <20080428092513.495378af.akpm@linux-foundation.org> <20080429175419.6c8a0ebf@strauss.suse.de> <20080430133824.GC18711@boogie.lpds.sztaki.hu> <20080430165131.7426d5d3@strauss.suse.de> <20080507114343.GB5583@boogie.lpds.sztaki.hu> <20080507144520.17e9902a@strauss.suse.de> <20080507134223.GB4278@boogie.lpds.sztaki.hu> <20080512142146.2a32793c@kopernikus.site> <20080513143917.GC17309@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513143917.GC17309@boogie.lpds.sztaki.hu>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:39:29PM +0200, Gabor Gombas wrote:
> On Mon, May 12, 2008 at 02:21:46PM +0200, Bernhard Walle wrote:
> 
> > Well, can you try if that really not happens without
> > CONFIG_HPET_EMULATE_RTC? The question is if that 64 interrupts per second really
> > cause a machine hang ...
> 
> I'll try when I have a little time...

Ok, it took much more time than I'd have liked, but now I'm having:

$ uname -a
Linux boogie 2.6.25 #3 SMP Thu Jun 12 13:32:35 CEST 2008 x86_64 GNU/Linux
$ grep EMULATE_RTC /boot/config-2.6.25
# CONFIG_HPET_EMULATE_RTC is not set
$ uptime
 19:07:17 up 3 days,  4:07, 12 users,  load average: 0.14, 0.31, 0.20

So I'd say it works.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
