Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYHKPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYHKPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYHKPtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:49:36 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48076 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYHKPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:49:35 -0400
Message-ID: <48A05F89.4070702@linux.vnet.ibm.com>
Date: Mon, 11 Aug 2008 21:19:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-ext4@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       aneesh.kumar@linux.vnet.ibm.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.27-rc1 - Filesystem warning on ext4 with e2fsck
References: <48A0127E.6000505@linux.vnet.ibm.com> <48A04C40.1040206@redhat.com>
In-Reply-To: <48A04C40.1040206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Kamalesh Babulal wrote:
>> Hi,
>>
>> After running the fsx linux test on the ext4 partition mounted with 
>> -o errors=panic,journal_async_commit, filesystem check is reporting
>> warning
>>
>> # /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda6 
>> e2fsck 1.41.0 (10-Jul-2008)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> /lost+found not found.  Create? no
>>
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>>
>> /dev/sda6: ********** WARNING: Filesystem still has errors **********
> 
> Was lost+found manually removed between mkfs & fsck?  (did you do an rm
> -rf * or similar ?)  That'd produce exactly the above warning, since you
> told e2fsck "-n" ...
> 
> -Eric
> --
Hi Eric,

Yes, the test program does a rm -rf * of the partition and  
usr/local/e2fsprogs/sbin/e2fsck -fvp /dev/sda6 helps. Sorry
for the noise.

-- 
Thanks & Regards,
Kamalesh Babulal.
