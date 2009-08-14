Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbZHNP7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbZHNP7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932603AbZHNP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:59:07 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:41488 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbZHNP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:59:06 -0400
X-ASG-Debug-ID: 1250265546-5cd500660000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
Date: Fri, 14 Aug 2009 11:58:59 -0400 (EDT)
From: Nicolas Pitre <nico@marvell.com>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH -rt] Fix kmap_high_get()
Subject: Re: [PATCH -rt] Fix kmap_high_get()
In-Reply-To: <1250258573.5241.1581.camel@twins>
Message-ID: <alpine.LFD.2.00.0908141152290.10633@xanadu.home>
References: <1249810600-21946-3-git-send-email-u.kleine-koenig@pengutronix.de>  <1250199243-18677-1-git-send-email-u.kleine-koenig@pengutronix.de> <1250258573.5241.1581.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1250265546
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Peter Zijlstra wrote:

> As to the patch, its not quite right.
> 
> From what I understand kmap_high_get() is used to pin a page's kmap iff
> it has one, whereas the result of your patch seems to be that it'll
> actually create one if its not found.

I don't have enough context to review this patch, but your understanding 
of the kmap_high_get() purpose is right.


Nicolas
