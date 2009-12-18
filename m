Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbZLRVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbZLRVVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbZLRVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:21:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbZLRVVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:21:38 -0500
Date: Fri, 18 Dec 2009 13:20:48 -0800
From: Greg KH <gregkh@suse.de>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [kernel] Re: Fw: Re: [kernel] Re: kernel/rcutree.h:301: sorry,
 unimplemented: inlining failed in call to 'rcu_bootup_announce': function
 body not available
Message-ID: <20091218212048.GA17834@suse.de>
References: <20091218200839.GF6712@linux.vnet.ibm.com>
 <20091218205456.GC6554@suse.de>
 <alpine.LNX.2.01.0912181202320.9874@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.0912181202320.9874@filesrv1.baby-dragons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:08:12PM -0900, Mr. James W. Laferriere wrote:
>  	Fyi ,  There is another driver that has this issue as well , 
> fusion/mptsas ,  has a 'inline' in drivers/message/fusion/mptsas.c at line 
> 105 that causes compile time failure in the same vein .
>  	See email to linux-scsi , Subject: linux-2.6.32.1 drivers/message/fusion/mptsas.c:106: sorry, unimplemented: inlining failed in call to 'mptsas_set_rphy': function body not available

Is there a patch in Linus's tree that solves this problem already?  If
so, what is the git commit id of it?

>  	I am also having 'ld' time troubles with 
> drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3' and 
> have sent emails to the appropriate lists & maintainers(I hope) .

When that gets fixed, let the stable@kernel.org address know the git
commit id that needs to be applied.

>  	Don't know if any of these would/should hold up the push of 32.2 or not 

Don't worry, it will not :)

thanks,

greg k-h
