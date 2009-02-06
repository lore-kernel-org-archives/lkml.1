Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZBFINT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZBFINT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZBFINE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:13:04 -0500
Received: from verein.lst.de ([213.95.11.210]:55130 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZBFIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:13:03 -0500
Date: Fri, 6 Feb 2009 09:12:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [Bug #12497] new barrier warnings in 2.6.29-rc1
Message-ID: <20090206081232.GA31358@lst.de>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.W2G.rvYiJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pWZw1SZjMCH.A.W2G.rvYiJB@chimera>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:23:59AM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12497
> Subject		: new barrier warnings in 2.6.29-rc1
> Submitter	: Christoph Hellwig <hch@lst.de>
> Date		: 2009-01-12 15:46 (24 days old)
> References	: http://marc.info/?l=linux-kernel&m=123177528217154&w=4
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>


We're now done to a single warning per mount instead of the previous
two:

[  485.307225] end_request: I/O error, dev vdb, sector 0
[  485.604639] Filesystem "vdb": Disabling barriers, trial barrier write failed
[  485.627352] XFS mounting filesystem vdb

but it's still around.
