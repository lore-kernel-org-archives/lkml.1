Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXHCA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXHCA0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbXHCA0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:26:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51053 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHCA0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:26:34 -0400
Date: Fri, 3 Aug 2007 09:27:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] 2.6.23-rc1-mm1 - fix missing numa_zonelist_order sysctl
Message-Id: <20070803092755.55220aa0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1186067258.5040.33.camel@localhost>
References: <1185994972.5059.91.camel@localhost>
	<20070802094445.6495e25d.kamezawa.hiroyu@jp.fujitsu.com>
	<1186067258.5040.33.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 11:07:38 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Of course, I don't have any idea of what is a "reasonable amount".
> Guess I could look at non-movable zone memory usage in a system at
> typical or peak load to get an idea.  Anyone have any data in this
> regard?
> 
I'm sorry that I have no data and idea. 
ZONE_MOVABLE is too young to be used under business workload...

just I feel...
Considering i686 which divides memory into NORMAL and HIGHMEM, it seems
that 4G to 8G servers looks stable under various workload in my experience.

Then, at least, 12.5% to 25% of "Total Memory - Hugepages" memory should be
under ZONE_NORMAL. But this is from experience of 32bit/SMP :(

Thanks,
-Kame

