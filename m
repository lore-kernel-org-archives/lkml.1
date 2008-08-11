Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYHKOih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYHKOih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYHKOi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:38:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYHKOi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:38:27 -0400
Message-ID: <48A04C40.1040206@redhat.com>
Date: Mon, 11 Aug 2008 09:27:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: linux-ext4@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       aneesh.kumar@linux.vnet.ibm.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.27-rc1 - Filesystem warning on ext4 with e2fsck
References: <48A0127E.6000505@linux.vnet.ibm.com>
In-Reply-To: <48A0127E.6000505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi,
> 
> After running the fsx linux test on the ext4 partition mounted with 
> -o errors=panic,journal_async_commit, filesystem check is reporting
> warning
> 
> # /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda6 
> e2fsck 1.41.0 (10-Jul-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> /lost+found not found.  Create? no
> 
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> /dev/sda6: ********** WARNING: Filesystem still has errors **********

Was lost+found manually removed between mkfs & fsck?  (did you do an rm
-rf * or similar ?)  That'd produce exactly the above warning, since you
told e2fsck "-n" ...

-Eric
