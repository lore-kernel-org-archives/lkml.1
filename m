Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXBGLxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXBGLxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161228AbXBGLxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:53:54 -0500
Received: from brick.kernel.dk ([62.242.22.158]:25264 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161232AbXBGLxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:53:54 -0500
Date: Wed, 7 Feb 2007 12:56:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomasz Kvarsin <kvarsin@gmail.com>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: warrning fix: unsigned->signed
Message-ID: <20070207115626.GF4487@kernel.dk>
References: <5157576d0702061339w28adbf5fp2dbc5e86661d894@mail.gmail.com> <20070206140936.24bbaded.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206140936.24bbaded.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06 2007, Andrew Morton wrote:
> On Wed, 7 Feb 2007 00:39:45 +0300
> "Tomasz Kvarsin" <kvarsin@gmail.com> wrote:
> 
> > While compiling my code, I always get bunch of warrning from headers,
> > here is fix for them:
> > __getblk is alawys called with unsigned argument,
> > but it takes signed, the same story with __bread,__breadahead and so on.
> 
> The patch seems OK, but I'm curious to know why you're seeing this warning
> and nobody else is.  Are you using a compiler other than gcc?  If gcc,
> which version?  Did you add any new compiler options?

While I'm not a big fan of fixing signed vs unsigned -W generated
warnings (they tend to cause more harm than good), this patch looks ok
to me as well.

-- 
Jens Axboe

