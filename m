Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZBKRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZBKRWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZBKRWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:22:41 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:44981 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZBKRWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:22:40 -0500
Message-ID: <49930977.4060904@gmail.com>
Date: Wed, 11 Feb 2009 20:23:03 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <499305AD.4020900@oracle.com> <20090211171324.GC13817@duck.suse.cz>
In-Reply-To: <20090211171324.GC13817@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Wed 11-02-09 09:06:53, Randy Dunlap wrote:
>   
>> akpm@linux-foundation.org wrote:
>>     
>>> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>>       
>> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:456: error: implicit declaration of function 'DQUOT_TRANSFER'
>> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:596: error: implicit declaration of function 'DQUOT_ALLOC_INODE'
>> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:597: error: implicit declaration of function 'DQUOT_DROP'
>> mmotm-2009-0210-1635/fs/reiser4/plugin/inode_ops.c:611: error: implicit declaration of function 'DQUOT_FREE_INODE'
>>     
>   Ah, out of tree filesystems... Could some of Reiser4 guys convert the
> quota names (they should be vfs_dq_transfer, vfs_dq_alloc_inode,
>   

Ok, I'll fix it at the near future.

Edward.

> vfs_dq_drop, vfs_dq_free_inode)? I suppose I could do it myself but I'm not
> sure if it won't clash with some other changes.
>   Thanks for report Randy.
>
> 									Honza
>   

