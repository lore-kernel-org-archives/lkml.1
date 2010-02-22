Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0BVIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:16:56 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:46180 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BVIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:16:55 -0500
Message-ID: <4B823D70.80800@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 09:16:48 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Nikanth Karthikesan <knikanth@suse.de>, Dave Chinner <david@fromorbit.com>,
       Ankit Jain <radical@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
References: <201002091659.27037.knikanth@suse.de> <201002111715.04411.knikanth@suse.de> <20100214213724.GA28392@discord.disaster> <201002151006.37294.knikanth@suse.de> <20100221142600.GA10036@localhost>
In-Reply-To: <20100221142600.GA10036@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Wu Fengguang wrote:
> Nikanth,
> 
>> I didn't want to impose artificial restrictions. I think Wu's patch set would 
>> be adding some restrictions, like minimum readahead. He could fix it when he 
>> modifies the patch to include in his patch set.
> 
> OK, I imposed a larger bound -- 128MB.
> And values 1-4095 (more exactly: PAGE_CACHE_SIZE) are prohibited mainly to 
> catch "readahead=128" where the user really means to do 128 _KB_ readahead.
> 
> Christian, with this patch and more patches to scale down readahead
> size on small memory/device size, I guess it's no longer necessary to
> introduce a CONFIG_READAHEAD_SIZE?

Yes as I mentioned before a kernel parameter supersedes a config symbol 
in my opinion too.
-> agreed

> Thanks,
> Fengguang
> ---

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
