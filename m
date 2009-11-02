Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZKBKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZKBKrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZKBKq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:46:58 -0500
Received: from [95.166.99.235] ([95.166.99.235]:41523 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbZKBKq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:46:56 -0500
Date: Mon, 2 Nov 2009 11:38:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Do not __always_inline bvec_kmap_irq() and
	bvec_kunmap_irq()
Message-ID: <20091102103817.GL10727@kernel.dk>
References: <1257024060-23039-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257024060-23039-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 31 2009, Alberto Bertogli wrote:
> On Tue, Feb 03 2009, Andrew Morton wrote:
> > The comment is wrong - this was a sparc requirement, long since removed.
> 
> So remove both the comment and the inline requirement, going back to the
> inline hint.

Thanks, applied to for-2.6.33.

-- 
Jens Axboe

