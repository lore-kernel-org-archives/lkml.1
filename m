Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZDTFgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZDTFgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZDTFgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:36:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46555 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZDTFgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:36:14 -0400
Message-ID: <49EC09BE.6090508@suse.de>
Date: Mon, 20 Apr 2009 11:05:58 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Andrew Morton <akpm@linux-foundation.org>, jamagallon@ono.com,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, lists@fuchsschwanzdomain.de
Subject: Re: Problems with default ACLs over NFS
References: <20090323222427.00bb24e7@werewolf.home> <20090326170513.4e7d377a.akpm@linux-foundation.org> <18513.1238194255@jrobl> <49EBFD18.4070607@suse.de> <7064.1240204656@jrobl>
In-Reply-To: <7064.1240204656@jrobl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> Suresh Jayaraman:
>> The following patch from Trond should fix this issue, I think.
>>
>>
>> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Date: Wed, 15 Apr 2009 13:58:45 -0400
>> Subject: [PATCH] NFS: Fix the XDR iovec calculation in nfs3_xdr_setaclargs
>>
>> Commit ae46141ff08f1965b17c531b571953c39ce8b9e2 (NFSv3: Fix posix ACL code)
>> introduces a bug in the calculation of the XDR header iovec. In the case
>> where we are inlining the acls, we need to adjust the length of the iovec
>> req->rq_svec, in addition to adjusting the total buffer length.
> 
> Thanx.
> But which tree is this patch applied?
> 

Not yet applied. I guess it's queued up in Trond's git.

Thanks,

-- 
Suresh Jayaraman
