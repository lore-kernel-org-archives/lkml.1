Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXKRWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXKRWqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXKRWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:46:22 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:48680 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXKRWqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:46:21 -0500
Message-ID: <4740C0BC.8010303@tlinx.org>
Date: Sun, 18 Nov 2007 14:46:20 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Config Q?: Preempt Model & Preempt Big Kern Lock
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not big deal, just some config-validity questions regarding
i386 preemption models and preemption of the big-kern lock.
I.e. the relevant options are:

(PM) "Preemption model", there are 3 choices (i386):
      (none) No Forced Preemption (Server)
      (vol) Voluntary Preempt (Desktop)
      (full) Preemptible Kernel (Low-Latency Desktop)
(PBL) "Preempt The Big Kernel Lock" (hint: use Y for desktop, else N)

===
Are these all "valid" config states?  Should they all be valid?

I.e., does it make sense to allow "PM==none && PBL==T" ?
Does it makes sense to allow "(PM==full) && PBL==F" ?

Is the issue of big-kernel-lock preemption of major consequence
these days, or should it work in all cases?  Are there cases
where one might want PBL==F?  Would they be limited to the
"PM=none" case?

Is this the right place or way to ask such questions, or to
get information?

In asking a similar information question, it seems that it
was preferred that a bug be filed.  Is that the case here?

Thanks,
Lin


