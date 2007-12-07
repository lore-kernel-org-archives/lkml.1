Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbXLGFnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbXLGFnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXLGFma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:42:30 -0500
Received: from gherkin.frus.com ([192.158.254.49]:36091 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbXLGFm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:42:29 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <20071206163305.c3587675.akpm@linux-foundation.org>
 "from Andrew Morton at Dec 6, 2007 04:33:05 pm"
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Dec 2007 23:42:25 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, mingo@elte.hu, mcree@orcon.net.nz,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org,
       kay.sievers@vrfy.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071207054225.06D68DBA3@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> If the implicated commit is the next one in time
> sequence relative to
> 
> # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> 
> then the test of whether I bisected correctly is as simple as applying
> the commit and seeing if things break, because I'm running on the
> kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right
> now.  Let me give that a try and I'll report back.

Verified that 6f37ac793d6ba7b35d338f791974166f67fdd9ba is the next
commit after the "good" kernel I'm running now.  The build is running,
and I should have an answer for us in a few hours.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
