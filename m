Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYECJFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYECJFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYECJFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:05:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbYECJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:05:05 -0400
Date: Sat, 03 May 2008 02:05:02 -0700 (PDT)
Message-Id: <20080503.020502.226847930.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503082849.GA29605@elte.hu>
References: <20080502.144827.158329188.davem@davemloft.net>
	<1209766054.6929.29.camel@lappy>
	<20080503082849.GA29605@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 May 2008 10:28:50 +0200

> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Yeah, I was thinking of a way for architectures to signify how much 
> > help they need building the various clocks. Sparc, power and s390 
> > would not need any help.
> 
> there's already such a mechanism in sched-devel.git (and has been there 
> for a week or two): an architecture can set time_sync_thresh to -1LL 
> during early bootup and essentially disable all the synchronization 
> logic.

Does it remove all of the code too? :-)

Please give us a config boolean.  The only platform for which
a run-time knob is even necessary is x86.

Thanks.
