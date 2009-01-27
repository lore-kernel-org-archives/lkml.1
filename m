Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZA0SDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZA0SDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZA0SDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:03:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:59607 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZA0SDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:03:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,333,1231142400"; 
   d="scan'208";a="104299934"
Subject: Re: [mmotm] Backtrace __change_page_attr_set_clr
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090127083705.56e210e6.akpm@linux-foundation.org>
References: <20090127110823.GO504@balbir.in.ibm.com>
	 <20090127083705.56e210e6.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 27 Jan 2009 10:02:54 -0800
Message-Id: <1233079374.15801.46.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 08:37 -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2009 16:38:23 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Hi, Andrew,
> > 
> > I see the following backtrace with 2009-01-16-16-18
> > 
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/mm/pageattr.c:560
> > __change_page_attr_set_clr+0xdc/0x891()
> > ...
> > CPA: called for zero pte. vaddr = ffff8800cfee2000 cpa->vaddr =
> > ffff8800cfee2000
> OK, thanks.  It looks like you cc'ed the right person ;)
> 
> The code in current linux-next has changed a bit since 16 Jan. 
> Hopefully this warning from dmidecode got fixed.

This is fixed recently. In linus's git, commit
a1e46212a410793d575718818e81ddc442a65283

thanks,
suresh

