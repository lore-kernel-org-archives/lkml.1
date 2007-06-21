Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXFUMc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXFUMc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXFUMcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:32:52 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41329 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbXFUMcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:32:51 -0400
Message-ID: <467A7113.7040307@bull.net>
Date: Thu, 21 Jun 2007 14:37:39 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
References: <1182201271.4883.22.camel@localhost.localdomain> <20070618164711.9de1c38e.akpm@linux-foundation.org> <20070620042434.GC12096@redhat.com>
In-Reply-To: <20070620042434.GC12096@redhat.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/06/2007 14:36:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/06/2007 14:36:47,
	Serialize complete at 21/06/2007 14:36:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, Jun 18, 2007 at 04:47:11PM -0700, Andrew Morton wrote:
> 
>  > Frankly, I find it very depressing that the kernel defaults matter.  These
>  > things are trivially tunable and you'd think that after all these years,
>  > distro initscripts would be establishing the settings, based upon expected
>  > workload, amount of memory, number and bandwidth of attached devices, etc.
> 
> "This is hard, lets make it someone else's problem" shouldn't ever be the
> answer, especially if the end result is that we become even more
> dependant on bits of userspace running before the system becomes useful.
> 
>  > Heck, there should even be userspace daemons which observe ongoing system
>  > behaviour and which adaptively tune these things to the most appropriate
>  > level.
>  > 
>  > But nope, nothing.
> 
> See the 'libtune' crack that people have been trying to get distros to
> adopt for a long time.
> If we need some form of adaptive behaviour, the kernel needs to be
> doing this monitoring/adapting, not some userspace daemon that may
> not get scheduled before its too late.
> 

I'm wondering whether AKT I proposed a couple of months ago wouldn't be 
more appropriate (provided that we find the perfect heuristics to tune 
the dirty_ratio ;-) )
see thread http://lkml.org/lkml/2007/1/16/16

Regards,
Nadia


