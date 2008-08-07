Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYHGMu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYHGMu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYHGMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37425 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYHGMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:50 -0400
Date: Thu, 7 Aug 2008 11:20:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/6] kexec jump: clean up #ifdef and comments
Message-ID: <20080807092058.GB372@atrey.karlin.mff.cuni.cz>
References: <1218099923.5164.32.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099923.5164.32.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> CONFIG_KEXEC_JUMP to make code looks cleaner.
> 
> Fix no longer correct comments of kernel_kexec().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  kernel/kexec.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1427,8 +1427,6 @@ static int __init crash_save_vmcoreinfo_
>  module_init(crash_save_vmcoreinfo_init)
>  
>  /**
> - *	kernel_kexec - reboot the system
> - *
>   *	Move into place and start executing a preloaded standalone
>   *	executable.  If nothing was preloaded return an error.
>   */

If it is not kerneldoc, it should not be /** .

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
