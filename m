Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936323Ab0B1Sqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:46:37 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57435 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab0B1Sqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:46:35 -0500
Date: Sun, 28 Feb 2010 19:46:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Message-ID: <20100228184634.GI5768@kernel.dk>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27 2010, Dmitry Monakhov wrote:
> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
> against this value. But in case of fs_optimization merge we compare
> with wrong value. This patch must be included in
>  b428cd6da7e6559aca69aa2e3a526037d3f20403
> But accidentally i've forgot to add this in the initial patch.
> To make things straight let's replace all such checks.
> In fact this makes code easy to understand.

Agree, applied.

-- 
Jens Axboe

