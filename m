Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYAWIIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYAWIIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYAWIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:08:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:56234 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYAWIIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:08:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,237,1199692800"; 
   d="scan'208";a="370289413"
Subject: Re: Could you please merge the x86_64 EFI boot support patchset?
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com,
       ak@suse.de, adaplas@pol.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080123014653.6261020c.pj@sgi.com>
References: <1194831950.17223.44.camel@caritas-dev.intel.com>
	 <20080123010051.969d21fd.pj@sgi.com>
	 <1201073166.4945.41.camel@caritas-dev.intel.com>
	 <20080123014653.6261020c.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 16:07:55 +0800
Message-Id: <1201075675.4945.44.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Jan 2008 08:07:18.0087 (UTC) FILETIME=[F8CF4570:01C85D96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 01:46 -0600, Paul Jackson wrote:
> Huang wrote:
> > This patchset has been merged into Linux 2.6.24.
> 
> Excellent.
> 
> > Unfortunately, the new EFI support patches do not use EFI memory map for
> > system boot up ...  So, I think the resolution for your problem is the
> > "struct setup_data" mechanism proposed by H. Peter Anvin.
> 
> So you're saying that the EFI in the kernel now still won't support more
> than 128 or so chunks of memory in the boottime memory map, because it
> still goes via the legacy E820h memory map code?

The kernel with EFI support can not support more than 128 or so chunks
of memory. Because the EFI memory map is converted to E820 memory map in
boot-loader (such as elilo).

> I'll have to study the code more and give it a try.
> 
> Are you optimistic that some variation of H. Peter Anvin's "struct
> setup_data" mechanism will make it into 2.6.25 or thereabouts?

I think it may be merged into 2.6.26.

Best Regards,
Huang Ying

