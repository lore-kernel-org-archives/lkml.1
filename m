Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZEENiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZEENiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZEENhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:37:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZEENhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:37:50 -0400
Date: Tue, 5 May 2009 09:37:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Message-ID: <20090505133743.GA663@infradead.org>
References: <1240646945-7970-1-git-send-email-abogani@texware.it> <20090425082349.GA2475@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425082349.GA2475@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 04:23:49AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 25, 2009 at 10:09:05AM +0200, Alessio Igor Bogani wrote:
> > Push BKL down into ->remount_fs()
> 
> Please also push down lock_super, no need to have two locking changes in
> this area just after another.

Do you plan to do that respin?  I will need the lock_super pushdown for
some sync work.  I can wait for you if you plan to submit it, otherwise
I'll out it on my TODO list.

