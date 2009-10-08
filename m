Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbZJHOQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbZJHOQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZJHOQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:16:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:35360 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754295AbZJHOQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:16:02 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/x4ggT+Vnx5qdrH8KTu7chSREMOp4FTgwGGykUAC
	gROc26opjvg75+
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091008064521.07fae137@infradead.org>
References: <200910051500.55875.elendil@planet.nl>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1255001062.7500.1.camel@marge.simson.net>
	 <20091008064521.07fae137@infradead.org>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 16:15:12 +0200
Message-Id: <1255011312.7294.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 06:45 -0700, Arjan van de Ven wrote:
> On Thu, 08 Oct 2009 13:24:22 +0200
> Mike Galbraith <efault@gmx.de> wrote:
> > Latencytop was accounting uninterruptible and interruptible sleep
> > time up to 5ms, which is not the latency the user is looking for.
> 
> it is for everything but the scheduler latency!
> 
> latencytop wants to show where you're waiting for disk, etc etc.
> that's not "time on runqueue".
> 
> for the scheduler delays a whole different codepath is used!

That explains.. a few things.

	-Mike

