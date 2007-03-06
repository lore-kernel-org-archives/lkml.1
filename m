Return-Path: <linux-kernel-owner+w=401wt.eu-S933987AbXCFHt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbXCFHt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933988AbXCFHt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:49:59 -0500
Received: from nn7.de ([85.214.94.156]:33154 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933987AbXCFHt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:49:58 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Soeren Sonnenburg <kernel@nn7.de>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S\. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <1173163783.3785.1.camel@localhost>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <1173140753.24738.246.camel@localhost.localdomain>
	 <1173163783.3785.1.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Mar 2007 08:49:55 +0100
Message-Id: <1173167395.4942.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 07:49 +0100, Soeren Sonnenburg wrote:
> On Tue, 2007-03-06 at 01:25 +0100, Thomas Gleixner wrote:
> > On Mon, 2007-03-05 at 15:45 -0800, Linus Torvalds wrote:
> > > 
> > > On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> > > > > 
> > > > > Subject    : macbook pro suspend to ram broken  (clockevents)
> > > > > References : http://lkml.org/lkml/2007/3/4/110
> > > > > Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> > > > > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > > > >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > > > > Status     : unknown
> > Does this make the problem go away ?
> 
> yes. works in my isolated test-setup. I'm now going to test this in
> git-HEAD with the full config.

*argh* when using the full config on HEAD something still causes a hang
on resume, but no time to trace it (the this probably new problem) down
atm :(

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
