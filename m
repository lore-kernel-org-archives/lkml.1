Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZKHGER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZKHGER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZKHGEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:04:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49298 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZKHGEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:04:15 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 09/13] sysfs: Implement sysfs_getattr & sysfs_permission
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-9-git-send-email-ebiederm@xmission.com>
	<4AF4D640.7030101@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 22:04:07 -0800
In-Reply-To: <4AF4D640.7030101@kernel.org> (Tejun Heo's message of "Sat\, 07 Nov 2009 11\:06\:56 +0900")
Message-ID: <m1tyx5o8mg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
>> index 1137418..c5eff49 100644
>> --- a/fs/sysfs/symlink.c
>> +++ b/fs/sysfs/symlink.c
>> @@ -214,6 +214,9 @@ const struct inode_operations sysfs_symlink_inode_operations = {
>>  	.readlink	= generic_readlink,
>>  	.follow_link	= sysfs_follow_link,
>>  	.put_link	= sysfs_put_link,
>> +	.setattr	= sysfs_setattr,
>
> It would be nice either to separate addition of setattr to symlinks
> into a separate patch or note it in the description.

Good point note added.

Eric
