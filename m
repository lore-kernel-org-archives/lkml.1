Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbZKZIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbZKZIOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759491AbZKZIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:14:05 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40336 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759481AbZKZIOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:14:04 -0500
Date: Thu, 26 Nov 2009 09:14:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: czoccolo@gmail.com, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key
	offset
Message-ID: <20091126081409.GL8742@kernel.dk>
References: <4B0E1E2F.9080604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E1E2F.9080604@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26 2009, Gui Jianfeng wrote:
> Hi Jens, Czoccolo
> 
> For the moment, different workload cfq queues are put into different
> service trees. But CFQ still uses "busy_queues" to estimate rb_key 
> offset when inserting a cfq queue into a service tree. I think this 
> isn't appropriate, and it should make use of service tree count to do 
> this estimation. This patch is for for-2.6.33 branch.

Makes sense, we've before discussed that using ->busy_queues isn't very
good, as it's not a stable count. service_tree count isn't that much
better, but for for-2.6.33 it does make more sense.

-- 
Jens Axboe

