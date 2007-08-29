Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXH2EDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXH2EDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbXH2EDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:03:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbXH2EDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:03:38 -0400
Date: Tue, 28 Aug 2007 21:03:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: Linux 2.6.23-rc4, maxcpus=1 regression
In-Reply-To: <20070829035554.GA838@elte.hu>
Message-ID: <alpine.LFD.0.999.0708282101540.25853@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org>
 <20070829035554.GA838@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Aug 2007, Ingo Molnar wrote:
> 
> maxcpus=1 fails to boot on my T60 laptop, it hangs in early bootup 
> (right after setting up the local APICs). I bisected it down to this 
> recent commit:
> 
> | commit 61ec7567db103d537329b0db9a887db570431ff4
> | Author: Len Brown <len.brown@intel.com>
> | Date:   Thu Aug 16 03:34:22 2007 -0400
> |
> |     ACPI: boot correctly with "nosmp" or "maxcpus=0"
> 
> reverting that commit makes the system boot again. I've attached the 
> .config.

Did you try -rc4? Commit 813409771731d80e6fa94199adf99f2269a4afc0 in 
particular ("fix maxcpus=N parsing") was supposed to fix that commit.

		Linus
