Return-Path: <linux-kernel-owner+w=401wt.eu-S935244AbYD1Rsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244AbYD1Rsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbYD1Rsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:48:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39141 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbYD1Rsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:48:30 -0400
Subject: Re: AIO/DIO lockup/crash
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <20080428090857.beb19a20.akpm@linux-foundation.org>
References: <1209385782.13978.17.camel@twins>
	 <20080428090857.beb19a20.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 19:48:29 +0200
Message-Id: <1209404909.13978.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 09:08 -0700, Andrew Morton wrote:

> erk, that's dio->bio_lock, isn't it?

Yep.

> That lock is super-simple and hasn't changed in quite some time.  If there
> has been major memory wreckage and we're simply grabbing at a "lock" in
> random memory then I'd expect the bug to maninfest in different ways on
> different runs?

Looks like it.

> I assume you have lots of runtime debugging options enabled.

Not on this particular run. I'll start a -git run this evening with most
of the debugging option enabled. It takes a few hours to reproduce, so I
let it run over-night.

