Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZEEUoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZEEUoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZEEUn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:43:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZEEUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:43:57 -0400
Date: Tue, 5 May 2009 16:43:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Message-ID: <20090505204352.GA23343@infradead.org>
References: <1240646945-7970-1-git-send-email-abogani@texware.it> <20090425082349.GA2475@infradead.org> <20090505133743.GA663@infradead.org> <63a49ef40905051239r61fe7f4cg6f24e13df30dc940@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a49ef40905051239r61fe7f4cg6f24e13df30dc940@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:39:38PM +0200, Alessio Igor Bogani wrote:
> >> Please also push down lock_super, no need to have two locking changes in
> >> this area just after another.
> >
> > Do you plan to do that respin? ?I will need the lock_super pushdown for
> > some sync work. ?I can wait for you if you plan to submit it, otherwise
> > I'll out it on my TODO list.
> 
> Apologize I have completely missed your first replay.
> 
> Let me two days for finish that task and for do build and boot tests.

Great!  Thanks a lot for the effort.

