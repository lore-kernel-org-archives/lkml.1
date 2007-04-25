Return-Path: <linux-kernel-owner+w=401wt.eu-S1423313AbXDYIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423313AbXDYIui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423317AbXDYIui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:50:38 -0400
Received: from wasp.net.au ([203.190.192.17]:48157 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423313AbXDYIuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:50:37 -0400
Message-ID: <462F1653.9040602@wasp.net.au>
Date: Wed, 25 Apr 2007 12:50:27 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au>	<46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com>	<17956.22235.574867.179016@notabene.brown>	<20070418123757.GC3796@kernel.dk>	<46261ACE.1050407@wasp.net.au>	<20070418132157.GC3720@kernel.dk>	<462B10C3.1030906@wasp.net.au>	<20070423073543.GE5311@kernel.dk>	<462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown>
In-Reply-To: <17967.4734.783140.512857@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:

> How likely it would be to get two requests with the same sector number
> I don't know.  I wouldn't expect it to ever happen - I have seen it
> before, but it was due to a bug in ext3.  Maybe XFS does it
> intentionally some times?

It certainly sounds like an odd thing to occur.

Even stranger that it's easier to hit on a degraded array or an array being checked.

I *am* using ext3 on this box (and all my boxes in fact)

> You could test this theory by putting a
>    WARN_ON(cfqq->next_rq == NULL);
> at the end of cfq_reposition_rq_rb, just after the cfq_add_rq_rb call.

I've done that.. now to wait for it to hit again.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
