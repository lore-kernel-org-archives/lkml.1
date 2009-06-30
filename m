Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZF3SFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZF3SFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZF3SFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:05:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44336 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZF3SFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:05:02 -0400
Date: Tue, 30 Jun 2009 11:04:49 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/pci: fix boundary checking when using root CRS
Message-ID: <20090630180449.GA7183@us.ibm.com>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42DA6F.2030305@kernel.org> <20090629181603.261ccd03@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629181603.261ccd03@jbarnes-g45>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:16:03PM -0700, Jesse Barnes wrote:
> On Wed, 24 Jun 2009 19:01:19 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > don't touch info->res_num if we are out of space
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Gary, any comments on these?

Jesse,
"[PATCH 1/3] x86/pci: fix boundary checking when using root CRS"
which convinced that my code was incorrect and
"[PATCH 2/3] x86/pci: get root CRS before scan childs -v3"
look good to me from both code review and functional [1] standpoints.
  Acked-by: <garyhade@us.ibm.com>
  Tested-by: <garyhade@us.ibm.com>

[1] Successful boot of patched 2.6.31-rc1 with pci=use_crs
    followed by successful hot-add and hot-remove of PCI-X
    and PCIe cards on an IBM x3850.

Thanks Yinghai.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

