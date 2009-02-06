Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZBFA7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZBFA7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZBFA6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:58:52 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37018 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbZBFA6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:58:51 -0500
Message-ID: <498B8B4D.3070603@lougher.demon.co.uk>
Date: Fri, 06 Feb 2009 00:58:53 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       snakebyte@gmx.de, sliedes@cc.hut.fi
Subject: Re: [PATCH] Squashfs: Fix oops when reading fsfuzzer corrupted filesystems
References: <E1LUY7A-0006q4-LB@dylan.lougher.demon.co.uk> <20090205122215.adcd18db.akpm@linux-foundation.org>
In-Reply-To: <20090205122215.adcd18db.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 04 Feb 2009 03:07:48 +0000
> Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> 
>> -	ERROR("sb_bread failed reading block 0x%llx\n", cur_index);
>> +	ERROR("squashfs_read_data failed to read block 0x%llx\n", index);
> 
> `index' has type u64.  You don't know what C type is used to implement
> u64, hence it must be cast to a known type before it can be passed to
> printk.
> 

Yeah missed that.   I resisted using u64 and used 'long long' for these
until very recently.

Phillip

