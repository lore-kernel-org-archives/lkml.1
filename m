Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXDQIN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXDQIN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXDQIN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:13:28 -0400
Received: from wasp.net.au ([203.190.192.17]:33878 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXDQIN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:13:26 -0400
Message-ID: <462481A0.4060707@wasp.net.au>
Date: Tue, 17 Apr 2007 12:13:20 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au>	<46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown>
In-Reply-To: <17956.22235.574867.179016@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Monday April 16, cebbert@redhat.com wrote:
>> cfq_dispatch_insert() was called with rq == 0. This one is getting really
>> annoying... and md is involved again (RAID0 this time.)
> 
> Yeah... weird.
> RAID0 is so light-weight and so different from RAID1 or RAID5 that I
> feel fairly safe concluding that the problem isn't in or near md.
> But that doesn't help you.

It's raid-5 here and it was degraded. I've just added the extra disk now and I've been running with 
the deadline scheduler to work around the issue. I'll add Neil's patch and try some tests with cfq 
tonight if I get the chance.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
