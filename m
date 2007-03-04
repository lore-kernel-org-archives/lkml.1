Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXCDHpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXCDHpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 02:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXCDHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 02:45:09 -0500
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:59622 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbXCDHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 02:45:08 -0500
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] [ANNOUNCE] RSDL completely fair starvation free interactive  cpu scheduler
Date: Sun, 4 Mar 2007 18:45:04 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200703041800.53360.kernel@kolivas.org>
In-Reply-To: <200703041800.53360.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041845.04560.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 18:00, Con Kolivas wrote:
> This message is to announce the first general public release of the
> "Rotating Staircase DeadLine" cpu scheduler.
>
> Based on previous work from the staircase cpu scheduler I set out to
> design, from scratch, a new scheduling policy design which satisfies every
> requirement for SCHED_NORMAL (otherwise known as SCHED_OTHER) task
> management.
>
> Available for download are:
>
>  A full rollup of the patch for 2.6.20:
> http://ck.kolivas.org/patches/staircase-deadline/sched-rsdl-0.26.patch

It's probably worth mentioning that this scheduler shows a not insignificant 
improvement in the mysql test case that recently received a lot of publicity. 
Why exactly that's the case I'm not sure but it may help track down what is 
actually responsible for the performance drop off as well. Note that the SMP 
balancing of this cpu scheduler is essentially unchanged from the mainline 
one.

-- 
-ck
