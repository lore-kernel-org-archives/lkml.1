Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbXJ2OnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbXJ2OnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbXJ2Omo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:42:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:47905 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbXJ2Omn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:42:43 -0400
In-Reply-To: <0CC518FE-47B0-4A32-B682-1CA5F7CBAC2F@kernel.crashing.org>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org> <1193188894.27073.20.camel@heimdal.trondhjem.org> <1954B8FA-6E29-4FB7-86B0-EA43AF8F2AAF@kernel.crashing.org> <2B2C1270-60FB-4830-A62C-D0357D2E1FB3@kernel.crashing.org> <1193335168.7705.39.camel@heimdal.trondhjem.org> <0CC518FE-47B0-4A32-B682-1CA5F7CBAC2F@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <45407DEE-37D0-437A-AF5F-17557D028E1A@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       chuck.lever@oracle.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: LTP ustat01 test fails on NFSROOT
Date: Mon, 29 Oct 2007 09:41:16 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26, 2007, at 4:42 AM, Kumar Gala wrote:

>
> On Oct 25, 2007, at 12:59 PM, Trond Myklebust wrote:
>
>> Could you please try the following patch?
>>
>> Cheers
>>   Trond
>> --------------------------------- CUT HERE  
>> -----------------------------
>> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Date: Thu, 25 Oct 2007 13:56:10 -0400
>> NFS: Fix the ustat() regression
>>
>> Since 2.6.18, the superblock sb->s_root has been a dummy dentry  
>> with a
>> dummy inode. This breaks ustat(), which actually uses sb->s_root in a
>> vfstat() call.
>>
>> Fix this by making the s_root a dummy alias to the directory inode  
>> that was
>> used when creating the superblock.
>>
>> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>> ---
>>
>>  fs/nfs/getroot.c |   81 +++++++++++++++++ 
>> +------------------------------------
>>  1 files changed, 27 insertions(+), 54 deletions(-)
>
> Any reason not to send this to Linus as a bug fix for 2.6.24 (and  
> possibly stable)?

ping.  would love to see this is Linus's tree.

- k
