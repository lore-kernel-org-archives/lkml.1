Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZLVLIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZLVLIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZLVLIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:08:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZLVLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:08:20 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B3009DC.7020407@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>
	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 12:06:41 +0100
Message-ID: <1261480001.4937.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
> 
> >  3) gets fragile at memory-pressure/reclaim
> 
> Shared dynamic pool is going to be affected by memory pressure no
> matter how you implement it.  cmwq tries to maintain stable level of
> workers and has forward progress guarantee.  If you're gonna do shared
> pool, it can't get much better. 

And here I'm questioning the very need for shared stuff, I don't see
any. That is, I'm not seeing it being worth the hassle.

