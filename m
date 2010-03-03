Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0CCJBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:01:11 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42165 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0CCJBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:01:10 -0500
Date: Wed, 3 Mar 2010 10:01:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/1] io-controller: Add a new interface "policy" for IO
	Controller
Message-ID: <20100303090108.GL5768@kernel.dk>
References: <4B8DFFD7.2000908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8DFFD7.2000908@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, Gui Jianfeng wrote:
> Currently, IO Controller makes use of blkio.weight to assign weight for
> all devices. Here a new user interface "blkio.policy" is introduced to 
> assign different weights for different devices. blkio.weight becomes the
> default value for devices which are not configured by blkio.policy.
> 
> You can use the following format to assigned specific weight for a given
> device:
> #echo "major:minor weight" > blkio.policy
> 
> major:minor represents device number.
> 
> And you can remove a policy as following:
> #echo "major:minor 0" > blkio.policy

Looks good to me. Vivek, any objections?

-- 
Jens Axboe

