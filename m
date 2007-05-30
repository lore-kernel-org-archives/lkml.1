Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXE3Nrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXE3Nrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXE3NrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:47:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:16333 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbXE3NrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ma4Hh9lkhsIcn4GFd5rmjKbz/t1i3L7xRVRFG59afkZyTU5OVLJ47RbJUPzKb7XOmKgPULfWyIHdUEffH45OD7qni9IV0Qi7YmnjQ/pse3O1/W+8QGAX9XfisVHqOJ1nql6CJhqr3gdGSvBVZwH3BiHBxZH1yUVEJB2pcQskiOU=
Message-ID: <465D8025.8090102@gmail.com>
Date: Wed, 30 May 2007 22:46:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sysfs: implement sysfs flags and SYSFS_FLAG_REMOVED
References: <11803701861778-git-send-email-htejun@gmail.com>	<11803701863982-git-send-email-htejun@gmail.com> <20070530135432.19422e01@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070530135432.19422e01@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 29 May 2007 01:36:26 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Rename sysfs_dirent->s_type to s_flags, pack type into lower eight
>> bits and use the rest for flags.  sysfs_type() can used to access the
>> type.  This patch also implements SYSFS_FLAG_REMOVED which is used to
>> improve sanity check in sysfs_deactivate().  The flag will also be
>> used to make directory entries reclamiable.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>>  fs/sysfs/dir.c        |   37 +++++++++++++++++++++++--------------
>>  fs/sysfs/inode.c      |    5 +++--
>>  fs/sysfs/mount.c      |    2 +-
>>  fs/sysfs/sysfs.h      |    7 ++++++-
>>  include/linux/sysfs.h |    4 ++++
>>  5 files changed, 37 insertions(+), 18 deletions(-)
> 
> This seems sane, but I'd split this into two patches: One introducing
> sysfs_type(), and one adding SYSFS_FLAG_REMOVED.

Yeap, I would too.  :-)  I'll split them up on next posting.

-- 
tejun
