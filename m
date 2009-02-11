Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZBKPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZBKPBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZBKPBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:01:09 -0500
Received: from relay1.sgi.com ([192.48.179.29]:52905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755181AbZBKPBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:01:08 -0500
Date: Wed, 11 Feb 2009 09:01:03 -0600
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next tree
Message-ID: <20090211150103.GA15814@sgi.com>
References: <20090209162520.GA4882@sgi.com> <20090210132555.be1c1462.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210132555.be1c1462.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:25:55PM -0800, Andrew Morton wrote:
> On Mon, 9 Feb 2009 10:25:20 -0600
> Dean Nelson <dcn@sgi.com> wrote:
> 
> > Fix the ia64 build error that occurs in the linux-next tree by introducing
> > an ia64 version of uv.h.  Additionally, clean up the usage of is_uv_system().
> 
> Would I be correct in believing that this repairs (and should be folded
> into)
> 
>   commit 5b221278d61e3907a5e4104a844b63bc8bb3d43a
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Wed Jan 21 11:30:07 2009 +0100
> 
>       x86: uv cleanup, build fix #2
> 
> ?
>
> (it looks like 5b221278d61e3907a5e4104a844b63bc8bb3d43a should be
> folded into something else, too.  What hath we wrought?)

Yes, it does fix an issue introduced by:

   commit: bdbcdd48883940bbd8d17eb01172d58a261a413a
   author: Tejun Heo <tj@kernel.org>
   date:   Wed, 21 Jan 2009 08:26:06 +0000

	x86: uv cleanup

which the commit you mention above attempted to fix.

I'll leave it to you and Ingo to determine whether my patch should be
folded into Ingo's or Tejun's patch.

Ingo, I see that you've applied my patch to your tip tree. What are
your thoughts on Andrew's question?

Thanks,
Dean

