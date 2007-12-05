Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbXLENQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbXLENQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 08:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXLENPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 08:15:54 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35669 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLENPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 08:15:53 -0500
Message-ID: <4756A477.1020903@s5r6.in-berlin.de>
Date: Wed, 05 Dec 2007 14:15:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: npiggin@suse.de
CC: akpm@linux-foundation.org, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] ieee1394: nopage
References: <20071205071547.701344000@nick.local0.net> <20071205071627.360419000@nick.local0.net> <4756A31C.5060405@s5r6.in-berlin.de>
In-Reply-To: <4756A31C.5060405@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> npiggin@suse.de wrote:
>> @@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
>>  	if (!dma->kvirt)
>>  		return -EINVAL;
>>  
>> -	/* must be page-aligned */
>> +	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
>>  	if (vma->vm_pgoff != 0)
>>  		return -EINVAL;
>>  
> 
> Are you sure that the comment is wrong?  Could it be that there are
> assumptions elsewhere which require page alignment?  (I should be able
> to answer that, but I'm not.)

PS:  Assumed the comment is wrong, is the code wrong then too?
-- 
Stefan Richter
-=====-=-=== ==-- --=-=
http://arcgraph.de/sr/
