Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZCRCWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZCRCWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZCRCWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:22:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:61332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbZCRCWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:22:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,381,1233561600"; 
   d="scan'208";a="498646182"
Date: Wed, 18 Mar 2009 10:23:19 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jan Beulich <jbeulich@novell.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: Fix the definition of PCI_PM_CTRL_NO_SOFT_RESET
Message-ID: <20090318022319.GA22809@yzhao-otc.sh.intel.com>
References: <49BFDB3C.76E4.0078.0@novell.com> <20090317173845.GR14127@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317173845.GR14127@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 01:38:45AM +0800, Matthew Wilcox wrote:
> On Tue, Mar 17, 2009 at 04:17:48PM +0000, Jan Beulich wrote:
> > From: Dexuan Cui <dexuan.cui@intel.com>
> > 
> > As per PCI Bus Power Management Interface Specification Revision 1.2
> > this is bit 3, not bit 2, of the Power Management Control/Status
> > register.
> 
> The same patch was already posted by Yu Zhao on February 25th and I
> reviewed it for Jesse.  I don't see it in any of the trees yet though ...
> (arguably, I should have picked it up for the fixes tree that I did
> while Jesse was away).

Sorry, I didn't bother you to pick it up for the rc because the wrong mask
doesn't cause any known problem so far (fortunately the wrong bit used as
No_Soft_Reset is hardwired to 0, which means PM restores the config space
for all the devices).
