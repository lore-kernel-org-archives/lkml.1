Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZHTBQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZHTBQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZHTBQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:16:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:60085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZHTBQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:16:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,411,1246863600"; 
   d="scan'208";a="485457343"
Subject: Re: [Bugme-new] [Bug 14003] New: Infinite loop on bootup while
 handling DMAR
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       "bero@arklinux.org" <bero@arklinux.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20090819142634.0fc550d1.akpm@linux-foundation.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 19 Aug 2009 18:15:28 -0700
Message-Id: <1250730929.2742.4.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 14:26 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Tue, 18 Aug 2009 14:54:22 GMT bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=14003
> > 
> >            Summary: Infinite loop on bootup while handling DMAR
> 
> That's a box-killing post-2.6.30 regression.
> 
> > 
> > Booting 64bit 2.6.31-rc6 on a hp xw4600 results in an infinite loop of
> > 
> > DMAR:[DMA READ] Request device [ff:1f.7] fault addr fffffffffffff000
> > DMAR:[fault reason 255] Unknown

I think David has a fix queued up for this already. Please check
http://git.infradead.org/iommu-2.6.git/commit/0815565a

thanks,
suresh

