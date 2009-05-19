Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZESWMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZESWMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZESWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:11:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:48480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZESWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:11:55 -0400
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
 flushing data
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com
In-Reply-To: <20090519175646.GF4140@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
	 <1242649192-16263-3-git-send-email-jens.axboe@oracle.com>
	 <4A1287FC.9020401@rsk.demon.co.uk> <20090519122324.GY4140@kernel.dk>
	 <1242740758.2754.33.camel@localhost.localdomain>
	 <20090519175646.GF4140@kernel.dk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 00:11:44 +0200
Message-Id: <1242771104.26820.504.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 19:56 +0200, Jens Axboe wrote:
> > Balance_dirty_pages contains Peter Zijlstra's per bdi write throttling
> > code and I wonder if it will need tuning for best performance with your
> > changes, just because some of its assumptions may have changed. I'll run
> > some tests here and see what happens. Peter may have some insight and
> > possibly useful test cases.
> 
> I'm assuming those are setting in -mm? I'll take a look.

Nah, those got merged ages ago (.24 iirc) and I don't think that would
need any touch ups wrt this series.


