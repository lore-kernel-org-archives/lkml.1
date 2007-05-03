Return-Path: <linux-kernel-owner+w=401wt.eu-S965748AbXECTUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbXECTUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965749AbXECTUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:20:33 -0400
Received: from mga07.intel.com ([143.182.124.22]:53753 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965748AbXECTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:20:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,487,1170662400"; 
   d="scan'208";a="223866487"
Message-ID: <463A35FE.3080501@linux.intel.com>
Date: Thu, 03 May 2007 12:20:30 -0700
From: chandramouli narayanan <mouli@linux.intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com>	<20070501190110.770881000@em64tdvp.jf.intel.com> <20070502195635.6fcc59d6.randy.dunlap@oracle.com>
In-Reply-To: <20070502195635.6fcc59d6.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Can you share EFI code as much as possible among ia64, i386,
> and x86_64 instead of duplicating it?
Hi Randy,

Based on the feedback from Andi and you, these are the areas:

1. conversion of EFI memory map to e820 map 
2. Consolidation/sharing of efi code among the architectures.
3. Coding style violations/typos/clarity in comments.

First  I apologize for the coding style violations where I should have 
done better. I will fix these in the next patch.

I would like to address the above in stages with patch updates. This 
will take me some time with the fixes and testing.

A while back, Edgar Hucek submitted a patch (probably 2.6.18 mm tree?) 
for efi to e820 memory mapping for i386.I don't see this code in the 
2.6.21 release which makes me wonder whether it was accepted and the 
history behind it. Any pointers in this regard?

thanks
- mouli
