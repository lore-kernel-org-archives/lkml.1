Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXCAVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXCAVxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030358AbXCAVxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:53:37 -0500
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:40589 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030357AbXCAVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:53:36 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Date: Fri, 2 Mar 2007 08:51:57 +1100
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200703012305.53997.kernel@kolivas.org> <20070301133004.GA32724@elte.hu>
In-Reply-To: <20070301133004.GA32724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703020851.57810.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 00:30, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > [...] Even though I'm finding myself defending code that has already
> > been softly tagged for redundancy, let's be clear here; we're talking
> > about at most a further 70ms delay in scheduling a niced task in the
> > presence of a nice 0 task, which is a reasonable delay for ksoftirqd
> > which we nice the eyeballs out of in mainline. Considering under load
> > our scheduler has been known to cause scheduling delays of 10 seconds
> > I still don't see this as a bug. Dynticks just "points it out to us".
>
> well, not running softirqs when we could is a bug. It's not a big bug,
> but it's a bug nevertheless. It doesnt matter that softirqs could be
> delayed even worse under high load - there was no 'high load' here.

Gotcha. I'll prepare a smt-nice removal patch shortly. 

-- 
-ck
