Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZFDIzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZFDIzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbZFDIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:54:52 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35260 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZFDIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:54:51 -0400
Message-ID: <4A278BA7.6040007@nokia.com>
Date: Thu, 04 Jun 2009 11:53:59 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/17] abstract out the super block clean/dirty state
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Jun 2009 08:54:00.0062 (UTC) FILETIME=[00A239E0:01C9E4F2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Hi,
> 
> here is a set of trivial patches which encapsulate the 'sb->s_dirt' variable
> into 3 new helper VFS functions:
> 
> * static inline void mark_sb_dirty(struct super_block *sb)
> * static inline void mark_sb_clean(struct super_block *sb)
> * static inline int sb_is_dirty(struct super_block *sb)
> 
> With these patches the whole Linux kernel tree has only 3 places where
> 'sb->s_dirt' is referred.

Sorry, forgot to mention that the patches were made on top of
the VFS tree:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-next

commit f932bb0daca28ffe69ec876043cac00bc9b50147
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue May 12 07:37:56 2009 -0400

    Fix nobh_truncate_page() to not pass stack garbage to get_block()

And they are also available at
git://git.infradead.org/users/dedekind/misc-2.6.git sb-helpers-v1

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
