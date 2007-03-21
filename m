Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbXCUKGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbXCUKGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXCUKGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:06:52 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39171 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXCUKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:06:51 -0400
Message-Id: <20070321095432.207136068@bull.net>
User-Agent: quilt/0.46-1
Date: Wed, 21 Mar 2007 10:54:32 +0100
From: Pierre.Peiffer@bull.net
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: [PATCH 2.6.21-rc4-mm1 0/4] Futexes functionalities and improvements
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/03/2007 11:08:50,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/03/2007 11:08:52,
	Serialize complete at 21/03/2007 11:08:52
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

	This is a re-send of a series of patches concerning futexes (here
after is a short description).
	I have reworked the patches to take into account the last changes
about futex, and this series should apply cleanly on -mm tree (the changes
mostly affect patch 2 "futex_wait uses hrtimer")
	I also took into account the remark of Peter Zijlstra in patch 3 
concerning futex_requeue_pi.

	Could you consider (again) them for inclusion in -mm tree ?

	All of them have already been discussed in January and have already 
been included in -rt for a while. I think that we agreed to potentially 
include them in the -mm tree.

	And, again, Ulrich is specially interested by sys_futex64.

There are:
    * futex uses prio list : allows RT-threads to be woken in priority order
instead of FIFO order.
    * futex_wait uses hrtimer : allows the use of finer timer resolution.
    * futex_requeue_pi functionality : allows use of requeue optimization for
PI-mutexes/PI-futexes.
    * futex64 syscall : allows use of 64-bit futexes instead of 32-bit. 


Thanks,


-- 
Pierre P.
