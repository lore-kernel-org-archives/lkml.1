Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZCJH3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZCJH3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZCJH3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:29:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZCJH3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:29:41 -0400
Date: Tue, 10 Mar 2009 08:29:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
Message-ID: <20090310072939.GC11787@kernel.dk>
References: <49B4DD9C.5030902@cn.fujitsu.com> <20090309092407.GI11787@kernel.dk> <yq1prgqy8wc.fsf@sermon.lab.mkp.net> <20090309192122.GZ11787@kernel.dk> <yq1wsay9h6m.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wsay9h6m.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> A dedicated bio_set for the integrity stuff would be the way to
> Jens> go, and that should provide you all the forward progress
> Jens> guarantees you need.
> 
> Ok. Against your for-linus branch...
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Great, that's also a lot less invasive and ifdef'y. Applied for 2.6.30.

-- 
Jens Axboe

