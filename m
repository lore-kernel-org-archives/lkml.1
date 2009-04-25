Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZDYIYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZDYIYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZDYIX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:23:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZDYIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:23:56 -0400
Date: Sat, 25 Apr 2009 04:23:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Message-ID: <20090425082349.GA2475@infradead.org>
References: <1240646945-7970-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240646945-7970-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:09:05AM +0200, Alessio Igor Bogani wrote:
> Push BKL down into ->remount_fs()

Please also push down lock_super, no need to have two locking changes in
this area just after another.

