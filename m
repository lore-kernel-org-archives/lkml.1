Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbZJELAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbZJELAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932604AbZJELAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:00:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbZJELAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:00:47 -0400
Date: Mon, 5 Oct 2009 13:00:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFS: introduce writeback wait queue
Message-ID: <20091005110010.GW26573@kernel.dk>
References: <20091004030153.GA20327@localhost> <20091004030504.GA20644@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004030504.GA20644@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Wu Fengguang wrote:
> Hi Jens,
> 
> This is a bug fix for 2.6.32. Maybe other not block-queue based
> filesystems will have similar issues ..

Not that I'm aware of, the NFS use is fairly special. Given that this is
purely in the realm of nfs/, I'll let Trond decide how to include and
push this (when a final patch is agreed upon).

Thanks for looking into this!

-- 
Jens Axboe

