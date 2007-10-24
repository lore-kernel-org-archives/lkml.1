Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbXJXBDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbXJXBDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbXJXBCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:02:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:36043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXJXBCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:02:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,320,1188802800"; 
   d="scan'208";a="304279087"
Subject: Re: [PATCH -v7 0/3] x86 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <471E7078.4050908@zytor.com>
References: <1193126765.23935.74.camel@caritas-dev.intel.com>
	 <471E7078.4050908@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2007 09:04:07 +0800
Message-Id: <1193187847.23935.95.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 24 Oct 2007 01:01:23.0316 (UTC) FILETIME=[65636B40:01C815D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 15:06 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > This patch set defines a 32-bit boot protocol for x86 platform, adds
> > an extensible boot parameter passing mechanism, export the boot
> > parameters via sysfs.
> > 
> > The patch set has been tested against kernel of git version
> > v2.6.23-6623-g55b70a0 (with Rusty's git tree pulled) on x86_64 and
> > i386.
> > 
> > This patch set is based on the proposal of Peter Anvin.
> > 
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> This patchset should spend a cycle in -mm before being merged, though.

Do you think it is possible that the 3rd patch of the patchset: document
for 32 bit boot protocol can be merged into upstream firstly? It has
been used by kexec/LinuxBIOS already and the EFI support patches depend
on it too.

Best Regards,
Huang Ying
