Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZJZRUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZJZRUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZJZRUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:20:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:39131 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZJZRUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:20:08 -0400
Date: Mon, 26 Oct 2009 18:20:12 +0100
From: Jan Kara <jack@suse.cz>
To: jens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Performance regression in IO scheduler still there
Message-ID: <20091026172012.GC7233@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I took time and remeasured tiobench results on recent kernel. A short
conclusion is that there is still a performance regression which I reported
few months ago. The machine is Intel 2 CPU with 2 GB RAM and plain SATA
drive. tiobench sequential write performance numbers with 16 threads:
2.6.29:              AVG       STDERR
37.80 38.54 39.48 -> 38.606667 0.687475

2.6.32-rc5:
37.36 36.41 36.61 -> 36.793333 0.408928 

So about 5% regression. The regression happened sometime between 2.6.29 and
2.6.30 and stays the same since then... With deadline scheduler, there's
no regression. Shouldn't we do something about it?

								Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
