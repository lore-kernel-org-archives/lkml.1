Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXDYKCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXDYKCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXDYKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:02:23 -0400
Received: from wasp.net.au ([203.190.192.17]:48393 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992522AbXDYKCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:02:23 -0400
Message-ID: <462F2727.7090205@wasp.net.au>
Date: Wed, 25 Apr 2007 14:02:15 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <17956.22235.574867.179016@notabene.brown> <20070418123757.GC3796@kernel.dk> <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk> <462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown> <20070425084607.GM9715@kernel.dk> <17967.8536.788076.851546@notabene.brown> <20070425094712.GP9715@kernel.dk>
In-Reply-To: <20070425094712.GP9715@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> It looks to be extremely rare. Aliases are extremely rare, front merges
> are rare. And you need both to happen with the details you outlined. But
> it's a large user base, and we've had 3-4 reports on this in the past
> months. So it obviously does happen. I could not make it trigger without
> doctoring the unplug code when I used aio.

Well, not that rare on this particular machine (I had a case where I could reproduce it in less than 
an hour of normal use previously on this box), and I've had it occur a number of times on my 
servers, I just never reported it before as I never took the time to set up a serial console and 
capture the oops.

> Here's a fix for it, confirmed.

Shall I leave the other debugging in, apply this and run it for a few hard days?

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
