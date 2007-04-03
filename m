Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbXDCU6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbXDCU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXDCU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:58:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:16538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbXDCU6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="224199927:sNHT62892991"
Date: Tue, 3 Apr 2007 13:57:25 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>
Subject: Re: [PATCH] msi: Immediately mask and unmask msi-x irqs.
Message-ID: <20070403205725.GD15704@linux-os.sc.intel.com>
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com> <m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com> <20070403185219.GB15704@linux-os.sc.intel.com> <m18xd9ckn4.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18xd9ckn4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 01:39:43PM -0600, Eric W. Biederman wrote:
> "Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:
> 
> Further now that we cache the msi message that read_msi_msg should go
> away and we should use the cached version from the msi_desc.

Ok. Then this patch is a must.

> > Don't we need the flush for the PCI_CAP_ID_MSI case aswell.
> 
> At least the 3.0 pci spec does not allow pci configuration access to
> be posted.  So unless we find some hardware that actually does post
> pci configuration writes we should be ok.

ok. Thanks.
