Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYEEMqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYEEMqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYEEMqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:46:24 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22859 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYEEMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:46:23 -0400
Message-ID: <481F0192.9080705@hp.com>
Date: Mon, 05 May 2008 08:46:10 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: More io-cpu-affinity results: queue_affinity + rq_affinity
References: <481B38D8.7080905@hp.com>
In-Reply-To: <481B38D8.7080905@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> Continuing to evaluate the potential benefits of the various I/O & CPU
> affinity options proposed in Jens' origin/io-cpu-affinity branch...
> 
> Executive summary (due to the rather long-winded nature of this post):
> 
> We again see rq_affinity has positive potential, but not (yet) able to
> see much benefit to adjusting queue_affinity.
> 
> ========================================================
> 
<snip>
> 
> =====================================================
> 
> As noted above, I'm going to do a series of runs to make sure this data
> holds over a larger data set (in particular the case where I/O is far -
> looking at QAF on & far to see if the 0.56% is truly representative).
> Suggestions for other tests to try and show/determine queue_affinity
> benefits are very welcome.


The averages (+ min/max error bars) for the reads/second & p_system
values when taken over 50 runs of the test can be seen at:

http://free.linux.hp.com/~adb/jens/r_s_50.png

and

http://free.linux.hp.com/~adb/jens/p_system_50.png

respectively. Still shows a potential big win w/ rq_affinity set to 1,
not much difference at all w/ queue_affinity settings (in fact, not
seeing any real movement at all when rq_affinity=1).



I'd still be willing to try other test scenarios to show how
queue_affinity can really help, but as for now, I'd suggest removing
that functionality for the present - getting rid of some code until such
time as we can prove its worth.

Alan
