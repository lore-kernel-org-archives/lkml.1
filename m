Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZLOJHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZLOJHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZLOJHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:07:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45296 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZLOJHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:07:43 -0500
Date: Tue, 15 Dec 2009 10:07:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: set workload as expired if it doesn't have any
	slice  left.
Message-ID: <20091215090742.GL8742@kernel.dk>
References: <4B26EC23.6020701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B26EC23.6020701@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Gui Jianfeng wrote:
> When a group is resumed, if it doesn't have workload slice left,
> we should set workload_expires as expired. Otherwise, we might
> start from where we left in previous group by error. 
> Thanks the idea from Corrado.

Thanks for working this out guys, I have applied it.

-- 
Jens Axboe

