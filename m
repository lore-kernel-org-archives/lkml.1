Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZG1UVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZG1UVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZG1UVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:21:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58793 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZG1UVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:21:05 -0400
Date: Tue, 28 Jul 2009 22:21:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] index of rq.count[]
Message-ID: <20090728202105.GA4148@kernel.dk>
References: <20090728.220623.39170303.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728.220623.39170303.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28 2009, Ryo Tsuruta wrote:
> Hi,
> 
> The following patch corrects that the index of rq.count[] should use
> BLK_RW_SYNC/BLK_RW_ASYNC instead of READ/WRITE.

It's not a bug fix as such, since they are both 0 and 1. But
for clarity it should be changed, that can wait until .32 though.

-- 
Jens Axboe

