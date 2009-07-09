Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbZGIQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbZGIQCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZGIQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:02:24 -0400
Received: from www.tglx.de ([62.245.132.106]:58976 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951AbZGIQCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:02:24 -0400
Date: Thu, 9 Jul 2009 18:01:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Freund <andres@anarazel.de>
cc: Jarek Poplawski <jarkao2@gmail.com>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused
 by netem)
In-Reply-To: <200907091728.23367.andres@anarazel.de>
Message-ID: <alpine.LFD.2.00.0907091801130.24704@localhost.localdomain>
References: <200907031326.21822.andres@anarazel.de> <20090709142414.GC3651@ami.dom.local> <alpine.LFD.2.00.0907091625540.24704@localhost.localdomain> <200907091728.23367.andres@anarazel.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres,

On Thu, 9 Jul 2009, Andres Freund wrote:
> On Thursday 09 July 2009 16:28:05 Thomas Gleixner wrote:
> > Please test them separate from each other. The one I sent in this
> > thread was just for narrowing down the issue, but I'm now quite sure
> > that they really hit the issue which is addressed by the hrtimer
> > patch.
> No crash yet. 15min running (seconds to a minute before).
> 
> Will let it run for some hours to be sure.

Which one of the patches are you testing ?

Thanks,

	tglx
