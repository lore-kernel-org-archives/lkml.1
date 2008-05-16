Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYEPBx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYEPBx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYEPBxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:53:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYEPBxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:53:19 -0400
Date: Thu, 15 May 2008 21:51:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080516015142.GB6926@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080514205204.GJ30469@redhat.com> <1210818762.23707.102.camel@caritas-dev.intel.com> <20080515200923.GC9718@redhat.com> <1210902514.23707.161.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210902514.23707.161.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 09:48:34AM +0800, Huang, Ying wrote:
> On Thu, 2008-05-15 at 16:09 -0400, Vivek Goyal wrote:
> [...]
> > Ok, You want to make BIOS calls. We already do that using vm86 mode and
> > use bios real mode interrupts. So why do we need this interface? Or, IOW,
> > how is this interface better?
> 
> It can call code in 32-bit physical mode in addition to real mode. So It
> can be used to call EFI runtime service, especially call EFI 64 runtime
> service under 32-bit kernel or vice versa.
> 
> The main purpose of kexec jump is for hibernation. But I think if the
> effort is small, why not support general 32-bit physical mode code call
> at same time.
> 

In general what's the environment requirements for EFI runtime 
services? I mean, just that processor should be in protected mode with
paging disabled or one need to stop all other cpus and devices and then make
the call (as we are doing in this case?). 

Thanks
Vivek
