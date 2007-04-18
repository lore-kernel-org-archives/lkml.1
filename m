Return-Path: <linux-kernel-owner+w=401wt.eu-S2992440AbXDRNTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992440AbXDRNTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXDRNTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:19:19 -0400
Received: from wasp.net.au ([203.190.192.17]:40790 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992440AbXDRNTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:19:18 -0400
Message-ID: <46261ACE.1050407@wasp.net.au>
Date: Wed, 18 Apr 2007 17:19:10 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk>
In-Reply-To: <20070418123757.GC3796@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> I had something similar for generic_unplug_request() as well, but didn't
> see/hear any reports of it being tried out. Here's a complete debugging
> patch for this and other potential dangers.
> 

I had a clean 2.6.21-rc7 that I forgot to change the default sched on take down my main server last 
night. Another oops of the same variety. Unfortunately only a digital photo to go by though.

I've removed Neil's patch, applied yours and fired it up on my 4 drive test box (the one that was 
causing the trouble before). I've finally scrounged another machine for a serial logger and I'll 
beat it until it breaks. Perhaps if I can get this to reliably trigger again we can track it down.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
