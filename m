Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZEMNIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZEMNIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZEMNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:08:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49046 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbZEMNIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:08:11 -0400
Date: Wed, 13 May 2009 15:08:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Peter W Morreale <pmorreale@novell.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: do we really want to export more pdflush details in sysctls
Message-ID: <20090513130811.GE4140@kernel.dk>
References: <20090513130128.GA10382@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513130128.GA10382@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13 2009, Christoph Hellwig wrote:
> Hi all,
> 
> commit fafd688e4c0c34da0f3de909881117d374e4c7af titled
> "mm: add /proc controls for pdflush threads" adds two more sysctl
> variables exposing details about pdflush threads.  At the same time
> Jens Axboe is working on the per-bdi writeback patchset which will
> hopefull soon get rid of the pdflush threads in their current form.
> 
> Is it really a good idea to expose more details now or should we revert
> this patch before 2.6.30 is out?

Pained me as well when updating the patchset. I see little value in
these knobs as it is, I'm imagining that the submitter must have had a
use case where it made some difference?

-- 
Jens Axboe

