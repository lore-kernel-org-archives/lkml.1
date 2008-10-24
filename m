Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYJXRrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYJXRrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYJXRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:47:29 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46184 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYJXRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:47:28 -0400
Message-ID: <49020A2A.5070809@nortel.com>
Date: Fri, 24 Oct 2008 11:47:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, efault@gmx.de,
       vatsa@in.ibm.com
Subject: Re: [PATCH 7/8] sched: non-zero lag renice
References: <20081024090611.936552213@chello.nl> <20081024091109.912152294@chello.nl>
In-Reply-To: <20081024091109.912152294@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2008 17:47:24.0150 (UTC) FILETIME=[92704160:01C93600]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

 > Then renicing, esp when lowering nice value (getting heavier), its possible
 > to get into a starvation scenario. If you got too much runtime as a very
 > light task, you get shot way far too the right, which means you'll have to
 > wait for a long time in order to run again.
 >
 > If during that wait you get reniced down, fairness would suggest you get run
 > earlier, because you deserve more time.
 >
 > This can be solved by scaling the vruntime so that we keep the real-time
 > lag invariant.

If we've already been shot way out to the right, presumably that would give us 
a large real-time lag.  If we renice to a lower nice level, wouldn't we want 
to reduce the real-time lag rather than make it constant?

Chris
