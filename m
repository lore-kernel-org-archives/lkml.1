Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987Ab0ASAzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0ASAzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712Ab0ASAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:55:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:48982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab0ASAzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:55:49 -0500
Message-ID: <4B550440.4040800@kernel.org>
Date: Tue, 19 Jan 2010 10:00:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 39/40] gfs2: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-40-git-send-email-tj@kernel.org>	 <1263807959.2715.4.camel@localhost>  <4B5444FD.4050500@kernel.org> <1263816447.2715.45.camel@localhost>
In-Reply-To: <1263816447.2715.45.camel@localhost>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 00:54:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/18/2010 09:07 PM, Steven Whitehouse wrote:
> Hmm, I thought I'd checked slow work pretty carefully before I decided
> to use it :( Looking at it though, its pretty unlikely that it would
> cause a problem. We can be 100% safe by just increasing the number of
> slow work threads to one per mounted gfs2 fs (assuming no other slow
> work users).

I don't think that will guarantee anything as there's nothing which
guarantees the new additional work to the gfs2 code.  At any rate,
these problems are pretty unlikely to happen but they still need
guarantees, so...

> Anyway, if its easy to solve that problem in the new code, thats all
> good :-) Thanks for pointing out this issue,

Yeap, I'll post updated patch soonish.

Thanks.

-- 
tejun
