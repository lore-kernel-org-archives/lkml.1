Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYHGM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYHGM4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYHGM4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:56:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:32102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYHGM4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="368546814"
Subject: Re: [PATCH 1/6] kexec jump: clean up #ifdef and comments
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080807092058.GB372@atrey.karlin.mff.cuni.cz>
References: <1218099923.5164.32.camel@caritas-dev.intel.com>
	 <20080807092058.GB372@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:29:04 +0800
Message-Id: <1218101344.5164.38.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 11:20 +0200, Pavel Machek wrote:
> Hi!
> 
> > CONFIG_KEXEC_JUMP to make code looks cleaner.
> > 
> > Fix no longer correct comments of kernel_kexec().
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> >  kernel/kexec.c |   11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -1427,8 +1427,6 @@ static int __init crash_save_vmcoreinfo_
> >  module_init(crash_save_vmcoreinfo_init)
> >  
> >  /**
> > - *	kernel_kexec - reboot the system
> > - *
> >   *	Move into place and start executing a preloaded standalone
> >   *	executable.  If nothing was preloaded return an error.
> >   */
> 
> If it is not kerneldoc, it should not be /** .

OK. I will fix it.

Best Regards,
Huang Ying


