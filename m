Return-Path: <linux-kernel-owner+w=401wt.eu-S1767111AbXDTOVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767111AbXDTOVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767114AbXDTOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:21:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50219 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767111AbXDTOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:21:46 -0400
Date: Fri, 20 Apr 2007 09:21:40 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dean Nelson <dcn@americas.sgi.com>
Cc: Jes Sorensen <jes@americas.sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       rja@sgi.com, holt@sgi.com
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
Message-ID: <20070420142140.GB17368@lnx-holt.americas.sgi.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969574439-git-send-email-ebiederm@xmission.com> <20070419165103.5b671b28.akpm@linux-foundation.org> <46285C6B.7080101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46285C6B.7080101@sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 08:23:39AM +0200, Jes Sorensen wrote:
> Andrew Morton wrote:
> >Another driver which should be fully converted to the kthread API:
> >kthread_stop() and kthread_should_stop().
> >
> >And according to my logs, this driver was added to the tree more than
> >a year _after_ the kthread interface was made available.
> >
> >This isn't good.
> 
> Andrew,
> 
> Per my previous response, I'd prefer to have either Russ or Robin ack
> the patch doesn't break before it's pushed to Linus.
> 
> I don't know much about the xpmem and I am not comfortable testing it.

I think this was originally coded with daemonize to avoid issues with
reaping children.  Dean Nelson can correct me if I am wrong.  I assume
this patch is going in as part of the set which will make these threads
clear themselves from the children list and if that is the case, I can
see no issues.

Thanks,
Robin
