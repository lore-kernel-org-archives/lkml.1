Return-Path: <linux-kernel-owner+w=401wt.eu-S936375AbXJQQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375AbXJQQce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXJQQcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:32:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12077 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761994AbXJQQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:32:23 -0400
Date: Wed, 17 Oct 2007 18:32:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017163216.GA15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <20071017155032.GA15215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017155032.GA15215@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i tried another bootup with the same kernel and the crash did not 
> > reoccur, so it seems to be spurious. This crash could be related to 
> > the scsi or block merges done in the past few days - never saw this 
> > before.
> 
> managed to trigger it a second time, so it seems rather reproducible:

Can you pull

git://git.kernel.dk/linux-2.6-block.git for-linus

and see if it still reproduces?

-- 
Jens Axboe

