Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZJDIsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZJDIsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 04:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZJDIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 04:48:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:40336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZJDIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 04:48:09 -0400
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed
 workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
       arjan@linux.intel.com
In-Reply-To: <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
	 <1254384558-1018-20-git-send-email-tj@kernel.org>
	 <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Oct 2009 10:49:39 +0200
Message-Id: <1254646179.26976.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 07:49 -0700, Andrew Morton wrote:
> This approach would appear to rule out the option of setting a work
> thread's state (scheduling policy, scheduling priority, uid, etc) to
> anything other than some default.
> 
> I guess that's unlikely to be a problem if we haven't yet had a need to
> do that, but I'd be a bit surprised to discover that nobody has done
> that sort of thing yet?  Nobody has niced up their workqueue threads?

-rt actually used to do PI on worklets, and that sure flipped the
scheduling class around a lot.
