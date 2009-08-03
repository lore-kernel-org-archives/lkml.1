Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZHCRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZHCRCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZHCRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:02:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:43297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZHCRCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="538210791"
Subject: Re: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array
 cases
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@linux.ie>,
       Arjan van de Ven <arjan@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
In-Reply-To: <20090803104454.GB18165@elte.hu>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
	 <20090803081110.GB32258@elte.hu>
	 <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie>
	 <4A76A24F.1030505@vmware.com> <20090803091954.GB9074@elte.hu>
	 <4A76B985.40202@vmware.com>  <20090803104454.GB18165@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 03 Aug 2009 09:58:25 -0700
Message-Id: <1249318705.27006.10777.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 03:44 -0700, Ingo Molnar wrote:
> ok - thanks for the explanation. Since you intentionally want to use 
> highmem pages (and your use is safe) i concur with your original 
> patch in its entirety - even if that planned highmem use is not 
> upstream yet. Will get it .31-wards ASAP.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

While none of the drivers in 2.6.30 use this interface, it will be good
if we backport this to 2.6.30-stable aswell.

Also, now that we have set_pages_array interface, do we still need the
set_memory_array_uc interface? Removing that should clean up the cpa
code a bit.

thanks,
suresh

