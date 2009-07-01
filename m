Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZGALxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZGALxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZGALxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:53:09 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42490 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZGALxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:53:08 -0400
Message-ID: <4A4B4E1B.6090900@in.ibm.com>
Date: Wed, 01 Jul 2009 17:22:59 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failure
References: <20090701160014.595e1338.sfr@canb.auug.org.au>
In-Reply-To: <20090701160014.595e1338.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> next-20090629 was fine.  The commits in 0630 and not in 0629 (from the
> fsnotify tree) are:
>
>       Audit: clean up the audit_watch split
>       audit: convert audit watches to use fsnotify instead of inotify
>       audit: redo audit watch locking and refcnt in light of fsnotify
>       audit: do not get and put just to free a watch
>       fsnotify: duplicate fsnotify_mark_entry data between 2 marks
>       fsnotify: allow addition of duplicate fsnotify marks
>       audit: reimplement audit_trees using fsnotify rather than inotify
>       inotify: deprecate the inotify kernel interface
>   
Stephen / Eric,

I too am facing similar issue on both Power and x86.
Culprit seems to be 2nd patch in the above list.

commit e1b79967e2b29839d16c12b534597a15d8630fc4
audit: convert audit watches to use fsnotify instead of inotify

I wasn't able to remove only patch 2 because of dependencies
on other patches. After i reverted patches 2 to 7 in the above
list, i was able to boot the machine. Then i applied patch 2
and the machine failed to boot.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

