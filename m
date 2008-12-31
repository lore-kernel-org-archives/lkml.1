Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYLaPeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYLaPeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYLaPeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:34:04 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:24700 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755801AbYLaPeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:34:02 -0500
Message-ID: <495B90E6.9010407@panasas.com>
Date: Wed, 31 Dec 2008 17:33:58 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] exofs: dir_inode and directory operations
References: <4947BFAA.4030208@panasas.com>	<4947C939.6030006@panasas.com> <20081229124759.d21e1410.akpm@linux-foundation.org>
In-Reply-To: <20081229124759.d21e1410.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Dec 2008 15:33:56.0311 (UTC) FILETIME=[317BFE70:01C96B5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 16 Dec 2008 17:28:57 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> implementation of directory and inode operations.
>>
>> * A directory is treated as a file, and essentially contains a list
>>   of <file name, inode #> pairs for files that are found in that
>>   directory. The object IDs correspond to the files' inode numbers
>>   and are allocated using a 64bit incrementing global counter.
>> * Each file's control block (AKA on-disk inode) is stored in its
>>   object's attributes. This applies to both regular files and other
>>   types (directories, device files, symlinks, etc.).
>>
>> ...
>>
>>  fs/exofs/dir.c   |  649 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> yes, this does look rather ext2-like ;)
> 
> How long ago was the code cloned from ext2?  iirc there have been a
> number of fairly subtle bugs fixed in ext2/dir.c over the past year or
> three.  If the code was not quite recently cloned then I'd suggest that
> you spend a bit of time looking through the ext2 changelogs, see if
> there are any bugfixes which needs to be ported.
> 
> 

Long! Like Linux-v2.6.10 ;)

I will git-log the files in question and see if any of the bugs
are relevant here. (They should be).

Thanks that is most valuable input.
Boaz
