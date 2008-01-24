Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYAXXNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYAXXNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYAXXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:13:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:57892 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYAXXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cASE+QTtHFehtbTjHhykw9x7gHZje+zGdvD3mXgBZv/sIrZNOiRq3gZv1qN9gHBb7EKxzIyJmDXq8IeprrX4RvWVU4r6bt0DnfHAk1+rpyhriqQVp9P+xjlnGOfCRVELBRK+oiXsa4PmjgZPdOqnR9aqr70G41lkBThhIUBWm0s=
Message-ID: <47991B7C.6000208@gmail.com>
Date: Fri, 25 Jan 2008 02:13:00 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Heikki Orsila <shdl@zakalwe.fi>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi>
In-Reply-To: <20080124225031.GC12172@zakalwe.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila пишет:
> On Fri, Jan 25, 2008 at 01:32:04AM +0300, Dmitri Vorobiev wrote:
>> diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
>> index 090b96e..ecc74bb 100644
>> --- a/fs/bfs/bfs.h
>> +++ b/fs/bfs/bfs.h
> ...
>> +/* inode.c */
>> +extern void dump_imap(const char *, struct super_block *);
>> +
> 
> Functions should not be externed, remove extern keyword.
> 

Care to explain why?

Following is an explanation why the contrary is probably true:

1) We have lots of precedents in existing code:

dmvo@cipher:~/Projects/misc/linux$ git-grep 'extern void' include | wc -l
5523
dmvo@cipher:~/Projects/misc/linux$

2) Linus' Coding style does not mandate what you requested.

3) The checkpatch.pl did not complain at this particular patch.

Thanks,

Dmitri

