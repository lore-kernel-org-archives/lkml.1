Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbXFLAfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbXFLAfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXFLAf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:35:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbXFLAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:35:26 -0400
Date: Mon, 11 Jun 2007 17:35:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
Message-Id: <20070611173504.862450d9.akpm@linux-foundation.org>
In-Reply-To: <18029.58838.518919.415999@notabene.brown>
References: <20070607114043.26967.patches@notabene>
	<1070607014653.27304@suse.de>
	<20070607181820.6b22bb29.akpm@linux-foundation.org>
	<18024.50064.799102.305585@notabene.brown>
	<20070607231042.97c7b68b.akpm@linux-foundation.org>
	<18029.58838.518919.415999@notabene.brown>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 10:16:22 +1000 Neil Brown <neilb@suse.de> wrote:

> > please consider incorporating scripts/checkpatch.pl into your patch
> > preparation toolchain.
> 
> Done... Any reason that it isn't executable (chmod +x)?

It is executable now (Linus did a chmod).

However I think it was wrong to do this.  Because lots of people will lose
that X bit (say, people who download and use patch-2.6.22.gz).  But _some_
people will have their X bit set, so they will go write scripts which
assume X permissions, only to find that those scripts break on other
people's systems.

So to force the lowest-common-denominator, we should have left X unset.  Oh
well.

