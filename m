Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIWBQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIWBQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYIWBQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:16:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:50634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYIWBQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,449,1217833200"; 
   d="scan'208";a="442395541"
Date: Mon, 22 Sep 2008 18:16:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923011620.GB25045@linux-os.sc.intel.com>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923005737.GA25045@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 05:57:38PM -0700, Siddha, Suresh B wrote:
> On Fri, Sep 19, 2008 at 05:33:20AM -0700, Cyrill Gorcunov wrote:
> > Interrupt remapping could lead to NULL dereference in case of
> > kzalloc failed and memory leak in other way. So fix the
> > both cases.
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >
> > Ingo, the patch is on top of applied one.
> >
> > If I remember correctly Suresh was involved in
> > this - so I think he could take a look and review
> > the patch (please).
> >
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

oops. Cyrill some typo here:

+       for (; apic > 0; apic--)
+               kfree(early_ioapic_entries[apic]);
+       kfree(early_ioapic_entries[apic]);
