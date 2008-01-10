Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYAJCHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYAJCHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYAJCH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:07:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:27079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbYAJCH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,264,1196668800"; 
   d="scan'208";a="492204140"
Subject: Re: [PATCH -mm 2/2] kexec/i386: kexec page table code clean up -
	page table setup in C
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Horms <horms@verge.net.au>, magnus.damn@gmail.com
In-Reply-To: <20080110010531.GA23143@redhat.com>
References: <1199847470.8126.16.camel@caritas-dev.intel.com>
	 <20080110010531.GA23143@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 10:08:09 +0800
Message-Id: <1199930889.8752.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 10 Jan 2008 02:07:17.0619 (UTC) FILETIME=[868EAC30:01C8532D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 20:05 -0500, Vivek Goyal wrote:
> On Wed, Jan 09, 2008 at 10:57:50AM +0800, Huang, Ying wrote:
> > This patch transforms the kexec page tables setup code from asseumbler
> > code to iC code in machine_kexec_prepare. This improves readability and
> > reduces code line number.
> > 
> 
> I think this will create issues for Xen. Initially page table setup
> was in C but Xen Guests could not modify the page tables. I think Xen
> folks implemented a hypercall where they passed all the page table pages
> and the control pages and then hypervisor executed the control page(which
> in turn setup the page tables). I think that's why page table setup
> code is on the control page in assembly.
> 
> You might want to go through Xen kexec implementation and dig through
> kexec mailing list archive.

OK, I will check the Xen kexec implementation.

> CCing Magnus and Horms. They had done the page tables related changes
> for Xen.

Best Regards,
Huang Ying

