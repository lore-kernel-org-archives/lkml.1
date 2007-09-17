Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbXIQJKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbXIQJKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbXIQIpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:45:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:8139 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbXIQIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,263,1186383600"; 
   d="scan'208";a="296615185"
Subject: Re: [RFC -mm 0/2] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709171040.27043.ak@suse.de>
References: <1190017572.5866.20.camel@caritas-dev.intel.com>
	 <200709171040.27043.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Sep 2007 16:47:35 +0800
Message-Id: <1190018855.5866.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 17 Sep 2007 08:45:41.0496 (UTC) FILETIME=[20DF9780:01C7F907]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 10:40 +0200, Andi Kleen wrote:
> On Monday 17 September 2007 10:26:12 Huang, Ying wrote:
> > For machine with some new BIOS other than legacy BIOS, such as EFI,
> > LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
> > based on legacy BIOS can not be used, so a 32-bit boot protocol need
> > to be defined.
> 
> The patch doesn't seem to be what you advertise in the description.
> Can you start with a patch that just implements the new boot protocol
> parsing for better review? The EFI code should be all in separate 
> patches.
> -Andi

The real contents of 32-bit boot protocol patch is is in another 2 mails
with the title:

[RFC -mm 1/2] i386/x86_64 boot: setup data
[RFC -mm 2/2] i386/x86_64 boot: document for 32 bit boot protocol

The EFI patch in this mail is just an example of 32-bit boot protocol
usage.

Best Regards,
Huang Ying
