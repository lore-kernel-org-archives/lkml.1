Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYI1QxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYI1QxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYI1QxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:53:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYI1QxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:53:14 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: dcg <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
From: Andi Kleen <andi@firstfloor.org>
References: <20080924183517.GA24209@nostromo.devel.redhat.com>
	<20080925091558.GE16734@elte.hu>
	<20080925161300.GA17162@nostromo.devel.redhat.com>
	<20080927185027.GB17867@elte.hu>
	<20080927211131.2e0b60f0@diego-desktop>
	<20080927191824.GC18619@elte.hu>
Date: Sun, 28 Sep 2008 18:53:13 +0200
In-Reply-To: <20080927191824.GC18619@elte.hu> (Ingo Molnar's message of "Sat, 27 Sep 2008 21:18:24 +0200")
Message-ID: <87skrkp5za.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> that's a property of early_printk() - it just doesnt listen to any of 
> the normal printk modifiers. (and that's the point of early_printk())
>
> could you please send a patch that only calls that early_printk() if 
> console_loglevel == 10? (i.e. if "debug" has been passed)

That would be useless because the parameters are not parsed at this point.

I personally find this early printk very useful for the reason Ingo
noted earlier (you know you're already past the boot loader). And that
can be very useful in debugging. Even for that that anonymous "quiet" person
who posted earlier. Two are not needed though.

-Andi
-- 
ak@linux.intel.com
