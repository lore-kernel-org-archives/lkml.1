Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZG2RJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZG2RJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZG2RJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:09:50 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:44845 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZG2RJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:09:49 -0400
Date: Wed, 29 Jul 2009 19:09:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
Message-ID: <20090729190938.1e4c45e9@skybase>
In-Reply-To: <200907291702.n6TH2LEt017305@d06av05.portsmouth.uk.ibm.com>
References: <200907291702.n6TH2LEt017305@d06av05.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 11:02:21 -0600
dwalker@fifo99.com wrote:

> On Wed, 2009-07-29 at 18:50 +0200, Martin Schwidefsky wrote:
> 
> > void clocksource_change_rating(struct clocksource *cs, int rating)
> 
> > the two functions do different things. What exactly is the idea you've
> > got in mind?
> 
> It's only the case when the rating goes to zero .. That makes the
> clocksource unusable, which is very much like unregistering it..

True, the clocksource code won't pick the clock any more as long as
there is an alternative clock available. It still shows up in the list
of clocks though and you can do an override with it. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

