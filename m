Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYFXICQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYFXICQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYFXIB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:01:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYFXIB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:01:56 -0400
Date: Tue, 24 Jun 2008 10:01:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: Re: [rfc patch 2/4] splice: remove steal from pipe_buf_operations
Message-ID: <20080624080152.GI20851@kernel.dk>
References: <20080621154607.154640724@szeredi.hu> <20080621154724.203822363@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621154724.203822363@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21 2008, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The 'steal' operation hasn't been used for some time.  Remove it and
> the associated dead code.  If it's needed in the future, it can always
> be easily restored.

I'd rather not just remove this, it's basically waiting for Nick to make
good on his promise to make stealing work again (he disabled it).

-- 
Jens Axboe

