Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYAWHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYAWHBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYAWHAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:00:52 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53758 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752975AbYAWHAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:00:51 -0500
Date: Wed, 23 Jan 2008 01:00:51 -0600
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com,
       ak@suse.de, adaplas@pol.net, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Could you please merge the x86_64 EFI boot support patchset?
Message-Id: <20080123010051.969d21fd.pj@sgi.com>
In-Reply-To: <1194831950.17223.44.camel@caritas-dev.intel.com>
References: <1194831950.17223.44.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Nov 2007, Huang Ying wrote:
> Could you please merge the following patchset:
> 
> [PATCH 0/2 -v3] x86_64 EFI boot support
> [PATCH 1/2 -v3] x86_64 EFI boot support: EFI frame buffer driver
> [PATCH 2/2 -v3] x86_64 EFI boot support: EFI boot document

Huang - what has become of this patchset?

We (SGI) have designs on a big honkin NUMA box using x86_64 arch, and
we are runnning up against the arbitrary limits on the memory map size
due to the ancient 4k zero page size limit (hence H. Peter Anvin added
to the CC list, since he knows a bazillion times more about any such
limits than I do.).  The limits on 128 or so local chunks of memory
imposed by the kernel code that invokes Int 15 E820h are too small for
us.

Since we are already accustomed to dealing with EFI on our IA64
Itanium boxes, I'm figuring that it will be easier in the short run,
and better in the long run, to just use EFI on these upcoming big
x86_64 NUMA boxes.

But we'd need to get this patch, or something equivalent, into the
Linux kernel in the next 2.6.* cycle or so, for this to work for us.

Also, is there a current version of this patch set available, against
either 2.6.24-rc8-mm1 or Ingo's recent x86 git tree?  I should try it
out.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
