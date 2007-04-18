Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXDRNW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXDRNW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992448AbXDRNW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:22:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32873 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992443AbXDRNW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:22:58 -0400
Date: Wed, 18 Apr 2007 15:21:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Brad Campbell <brad@wasp.net.au>
Cc: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070418132157.GC3720@kernel.dk>
References: <4621FAF0.7000705@wasp.net.au> <46220339.9080205@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk> <46261ACE.1050407@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46261ACE.1050407@wasp.net.au>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18 2007, Brad Campbell wrote:
> Jens Axboe wrote:
> 
> >I had something similar for generic_unplug_request() as well, but didn't
> >see/hear any reports of it being tried out. Here's a complete debugging
> >patch for this and other potential dangers.
> >
> 
> I had a clean 2.6.21-rc7 that I forgot to change the default sched on take 
> down my main server last night. Another oops of the same variety. 
> Unfortunately only a digital photo to go by though.
> 
> I've removed Neil's patch, applied yours and fired it up on my 4 drive test 
> box (the one that was causing the trouble before). I've finally scrounged 
> another machine for a serial logger and I'll beat it until it breaks. 
> Perhaps if I can get this to reliably trigger again we can track it down.

Thanks for testing Brad, be sure to use the next patch I sent instead.
The one from this mail shouldn't even get you booted. So double check
that you are still using CFQ :-)

-- 
Jens Axboe

