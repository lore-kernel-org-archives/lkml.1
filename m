Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbXCMJ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbXCMJ46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXCMJ46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:56:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44312 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXCMJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:56:57 -0400
Message-Id: <20070313095203.154246923@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 13 Mar 2007 10:52:03 +0100
From: Pierre.Peiffer@bull.net
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: [PATCH 2.6.21-rc3-mm2 0/4] Futexes functionalities and improvements
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/03/2007 10:58:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/03/2007 10:58:48,
	Serialize complete at 13/03/2007 10:58:48
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

	This is a re-send of a series of patches concerning futexes (here after is a short description)

	Could you consider them for inclusion in -mm tree ?

	All of them have already been discussed in January and have already been included in -rt for a while. I think that we agreed to potentially include them in the -mm tree.

	Ulrich is specially interested by sys_futex64.

There are:
    * futex uses prio list : allows RT-threads to be woken in priority order
instead of FIFO order.
    * futex_wait uses hrtimer : allows the use of finer timer resolution.
    * futex_requeue_pi functionality : allows use of requeue optimization for
PI-mutexes/PI-futexes.
    * futex64 syscall : allows use of 64-bit futexes instead of 32-bit. 


Note: it does not inlcude the fix "PI state locking fix" sent yesterday by Ingo.

Thanks,

-- 
Pierre
