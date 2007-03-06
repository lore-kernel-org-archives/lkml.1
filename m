Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbXCFM6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbXCFM6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933877AbXCFM6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:58:53 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:36107 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbXCFM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:58:52 -0500
Date: Tue, 6 Mar 2007 14:55:30 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306125530.GA6981@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> <20070306104618.GA5792@mellanox.co.il> <1173180977.9161.14.camel@localhost> <20070306120701.GA29599@elte.hu> <20070306125119.GA6119@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306125119.GA6119@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: [5/6] 2.6.21-rc2: known regressions
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > BTW, Ingo, can you suspend/resume any number of times with this 
> > > > patch?
> > > 
> > > well I could at least two times in a row in my minimalistic setup 
> > > (config attached) however using the full kernel config it still 
> > > hangs ... (config also attached in case you watn to compare it).
> > 
> > i can confirm that with your full config i see a hang too. This is 
> > most likely the ACPI problem - we are debugging this now and will come 
> > up with a patch.
> 
> update: this only happens with simulation, and even then it's not a full 
> hang but 'hangs until i hit a key'. With real resume i'm hitting a real 
> key anyway so it doesnt hang.

How 'bout my .config?


-- 
MST
