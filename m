Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXIQN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXIQN4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbXIQN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:56:12 -0400
Received: from nn7.de ([85.214.94.156]:34731 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXIQN4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:56:09 -0400
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
From: Soeren Sonnenburg <kernel@nn7.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200709161815.39633.nickpiggin@yahoo.com.au>
References: <1189675222.5352.10.camel@localhost>
	 <1189849627.4270.12.camel@localhost> <1189851735.4270.19.camel@localhost>
	 <200709161815.39633.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Sep 2007 15:43:39 +0200
Message-Id: <1190036619.4757.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-16 at 18:15 +1000, Nick Piggin wrote:
> On Saturday 15 September 2007 20:22, Soeren Sonnenburg wrote:
> > On Sat, 2007-09-15 at 09:47 +0000, Soeren Sonnenburg wrote:
> 
> > > Memtest did not find anything after 16 passes so I finally stopped
> it
> > > applied your patch and used
> > >
> > > CONFIG_DEBUG_SLAB=y
> > > CONFIG_DEBUG_SLAB_LEAK=y
> > >
> > > and booted into the new kernel.
> > >
> > > A few hours later the machine hung (due to nmi watchdog rebooted),
> so I
[...]
> > > swap_dup: Bad swap file entry 28c8af9d
> 
> Hmm, this is another telltale symptom of either bad hardware
> or a memory scribbling bug.

Since this morning, the machine is running with the dvb driver for that
certain card unloaded...

Anyway you convinced me that it is the bad saa7134_dvb drivers (driving
the asus p7131) fault. As the driver seems huge, I wonder whether there
are a) other config debug options that could aid in debugging b) what
the names of certain io functions are that may cause this...

Thanks a lot!
Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
