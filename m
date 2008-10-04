Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYJDVuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYJDVuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYJDVt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:49:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60756 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYJDVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=URRt4lR7a3YiZeQXxWkYi0wXqU2JQjnkO+mQLBmMe6n53XC+8QTUG/DTwNyqhYfxxV
         UnbFL5k1wdyzsDsvSK2jQU3I46wLsGht9wYTMkouFqZwkAPGN2QyHFxrC7POB3RHjlEO
         sdeuL89x+ativkvhCEAXou9RfhzOUQoE5ldJ4=
Date: Sun, 5 Oct 2008 01:52:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Adam Litke <agl@us.ibm.com>
Subject: Re: [RFC PATCH] Report the shmid backing a VMA in maps
Message-ID: <20081004215228.GA20048@x200.localdomain>
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie> <1223052415-18956-3-git-send-email-mel@csn.ul.ie> <20081004205650.CE47.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004205650.CE47.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 09:04:03PM +0900, KOSAKI Motohiro wrote:
> In the other hand, huge page is often used via ipc shm, not mmap.
> So, administrator often want to know relationship of memory region and shmid.
> 
> Then, To add shmid attribute in /proc/{pid}/maps is useful.
> 
> 
> In addition, shmid information is not only useful for huge page, but also for normal shm.
> Then, this patch works well on normal shm.

> 2000000000500000-2000000000900000 rw-s 00000000 00:09 0                  /SYSV00000000 (deleted) (shmid=0)
> 2000000000900000-2000000000d00000 rw-s 00000000 00:09 32769              /SYSV00000000 (deleted) (shmid=32769)
							^^^^^						  ^^^^^

shmid is already in place, and no, it's not a coincidence ;-)
