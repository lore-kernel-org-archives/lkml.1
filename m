Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXEJHha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXEJHha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXEJHhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:37:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:2470 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbXEJHhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=tfdRwvQZC1ORzgZgUsRx2cdtt1ayaCHZi79IrwjMWQ4ufrsvy+vZWFZl+u9LJpc20v90CapW2ac++eEB/29cZSNBis/vl7njbtX/Ru2j8SHMRB95V1WNZBPqb03hLoxt6W2G1l9clesRHYTGmoOB6J7m4o+Ps3YX0Ar3rwEnnpA=
Message-ID: <4642CB06.2080409@gmail.com>
Date: Thu, 10 May 2007 15:34:30 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Hi, I have one question about rt_mutex.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven.

Nice to meet you again.

I have read the rt-mutex-design.txt that you wrote. That is excellent
description of rt_mutex. But I have a question for rt_mutex.

As you said:


> Now since mutexes can be defined by user-land applications, we don't
want a DOS
> type of application that nests large amounts of mutexes to create a large
> PI chain, and have the code holding spin locks while looking at a large
> amount of data. So to prevent this, the implementation not only implements
> a maximum lock depth, but also only holds at most two different locks at a
> time, as it walks the PI chain. More about this below.

After read the implementation of rt_mutex_adjust_prio_chain(), I found
the we really require maximin lock depth (1024 default), but I can not
see the check for more same locks duplication. Does this doc is
inconsistent with code?

Thanks in advanced.

Good luck.
- Li Yu
