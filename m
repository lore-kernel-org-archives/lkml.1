Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZHLJk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZHLJk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZHLJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:40:57 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49435 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZHLJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F7c0dzgt+y6obsCLIRllIv/KL5N6ExR2tTx2HsZMIz+Gm623pXw4+8BYUrBfYnmu/V
         aVgNwTqg3b6dCRU4lqCoGw9VIBsrwIjyzs2ACdt2gazt0Areha3wasbXQuRWB94585mP
         6r+ER1BUFuxbZp33yMzXWLnwC5Rnv/Xj0kiww=
Date: Wed, 12 Aug 2009 17:43:09 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xiyou.wangcong@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] kcore clean up and enhance
Message-ID: <20090812094309.GB5929@cr0.nay.redhat.com>
References: <20090806192416.4f94be76.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806192416.4f94be76.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 07:24:16PM +0900, KAMEZAWA Hiroyuki wrote:
>
>This patch set is for /proc/kcore. By this,
>
> - many per-arch hooks are removed.
>
> - /proc/kcore will know really valid physical memory area.
>
> - /proc/kcore will be aware of memory hotplug.
>
> - /proc/kcore will be architecture independent i.e.
>   if an arch supports CONFIG_MMU, it can use /proc/kcore.
>   (if the arch uses usual memory layout.)



Hi, this version looks fine for me, I can't spot any obvious
mistakes now.

I would like to see these patches merged into -mm, so that
I can test the whole stuff about /proc/kcore.

Andrew, could you take these?

Thanks!


>
>BTW, I'll be on small trip from Aug/11 to Aug/17. So, my rtt may be
>bad in the next week.

Have a good trip! :)
