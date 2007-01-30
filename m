Return-Path: <linux-kernel-owner+w=401wt.eu-S965600AbXA3RHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbXA3RHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965611AbXA3RHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:07:04 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:14130 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965600AbXA3RHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:07:01 -0500
Message-ID: <45BF7DBD.8000606@sw.ru>
Date: Tue, 30 Jan 2007 20:17:49 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, dev@openvz.org
Subject: Re: [PATCH 1/2] add lazy_getattr and lazy_readdir patches that defer
 i_ino assignment
References: <200701301538.l0UFcGNX027715@dantu.rdu.redhat.com> <45BF7499.1000805@sw.ru> <45BF754A.1030307@redhat.com>
In-Reply-To: <45BF754A.1030307@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>Jeff,
>>
>>taking into account the discussion about unawarness/uncertainty
>>of whether *unique* inode number is needed at all on pipe fds and such
>>do we need this at all?
>>
>>Thanks,
>>Kirill
>>
> 
> 
> Fair enough, perhaps we should just not worry about it, and assume that there 
> might be collisions.
> 
> If so, I should probably just have Andrew withdraw the patch I submitted earlier 
> to hash the inodes for pipefs. I'll look at other callers of new_inode and fix 
> up any of the ones that need fixing.
> 
> Does that seem like the most reasonable approach?
yep!

Thanks,
Kirill

