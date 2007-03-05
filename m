Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbXCEXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbXCEXub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXCEXub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:50:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbXCEXua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:50:30 -0500
Date: Mon, 5 Mar 2007 15:45:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
In-Reply-To: <1173138193.24738.236.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
 <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> > 
> > Subject    : macbook pro suspend to ram broken  (clockevents)
> > References : http://lkml.org/lkml/2007/3/4/110
> > Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > Status     : unknown
> 
> I can reproduce this on my dual core VAIO. There are some issues:

Yeah, I think I can too, on my dual-core Mac Mini. 

I'm not done with my bisection, but e9e2cdb4 is among the 28 commits left, 
so I'm pretty sure I'm hitting the same bug. I'll do a few more bootups to 
be 100% sure.

		Linus
