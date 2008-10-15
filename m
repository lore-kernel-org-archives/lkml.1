Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJOHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJOHzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYJOHzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:55:36 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:43934 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYJOHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:55:36 -0400
Date: Wed, 15 Oct 2008 13:23:51 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Brice Goglin <brice@myri.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc
	selectsCONFIG_INTEL_IOATDMA=y
Message-ID: <20081015075351.GA7925@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081013101559.GA14372@linux.vnet.ibm.com> <20081013112631.GD29938@cs181140183.pp.htv.fi> <36D9DB17C6DE9E40B059440DB8D95F52066E2EAE@orsmsx418.amr.corp.intel.com> <48F391B9.1000206@myri.com> <20081013183503.GA28133@cs181140183.pp.htv.fi> <48F4627E.30300@myri.com> <36D9DB17C6DE9E40B059440DB8D95F52066E36C7@orsmsx418.amr.corp.intel.com> <20081014175822.GA4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081014175822.GA4710@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk <bunk@kernel.org> [2008-10-14 20:58:22]:

> On Tue, Oct 14, 2008 at 09:10:33AM -0700, Brandeburg, Jesse wrote:
> > Brice Goglin wrote:
> > > Adrian Bunk wrote:
> > >> But considering that igb is in a similar situation it would be nice
> > >> if all 3 drivers would handle it the same way.
> > >> 
> > > 
> > > Jesse,
> > > What do you think of the below patch?
> > 
> > Seems like a much better solution.  I can have Jeff Kirsher work on the
> > equivalent patches for igb, and ixgbe today.
> > 
> > > I am not very familiar with Kconfig, but it seems to solve the
> > > problem. 
> > > If a Kconfig guru could double-check...
> > 
> > Yeah, please Kconfig gurus on the list have a quick look.
> 
> Brice's patch looks fine.
> 
> cu
> Adrian
> 

Thanks, the patch fixes the build failure with CONFIG_MYRI10GE=y, once
patch for CONFIG_IXGBE are send out by Jeff Kirsher/Jesse, I will retest
them.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
