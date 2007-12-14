Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbXLNVL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbXLNVL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbXLNVLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:11:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:55815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXLNVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:11:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="439440632"
Date: Fri, 14 Dec 2007 13:10:39 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214211039.GB717@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com> <m1wsrhq4zl.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsrhq4zl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:23:26PM -0700, Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> Ok.  My analysis here was wrong.  Currently pgprot_noncached and
> ioremap_nocache are out of sync.  With ioremap_nocache only specifying
> _PAGE_PCD and pgprot_noncached specifying _PAGE_PCD | _PAGE_PWT.
> 
> So I don't have a clue how someone could reprogram the mtrrs currently
> and expect things to work.
> 
> ...
> 
> If we bother to ask ioremap for memory that is not cached, the last
> thing in the world we want is the MTRRs upgrading that to write combining.
> So ioremap_nocache has been slightly buggy for ages.  ioremap_nocache
> and PAGE_KERNEL_NOCACHE should get _PAGE_PWT added to their
> definitions.
> 
> Could we please get a cleanup patch at the beginning of this patchset
> or that comes before it that fixes ioremap_nocache on x86?
> 
> That will make us a lot more git-bisect safe.

Ok. I will send a separate patch  fixing ioremap_nocache on x86.

thanks,
suresh
