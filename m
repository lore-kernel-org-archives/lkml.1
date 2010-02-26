Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621Ab0BZJEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:04:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6017 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935603Ab0BZJEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:04:36 -0500
X-IronPort-AV: E=Sophos;i="4.49,545,1262581200"; 
   d="scan'208";a="7366475"
Subject: Re: VMI and kmap_atomic_pte paravirt_op
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "akataria@vmware.com" <akataria@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1267129930.10104.4.camel@ank32>
References: <1267127532.2488.7.camel@localhost.localdomain>
	 <1267129930.10104.4.camel@ank32>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 26 Feb 2010 09:04:32 +0000
Message-ID: <1267175072.11737.11908.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 20:32 +0000, Alok Kataria wrote:
> Hi Ian, 
> 
> On Thu, 2010-02-25 at 11:52 -0800, Ian Campbell wrote:
> > Hi Alok,
> > 
> > How critical is the vmi_kmap_atomic_pte pv_mmu_op hook to VMI? Is it
> > required for correct functionality or is it simply an optimisation?
> > 
> > We think we may be able to do away with the Xen version of the hook and
> > if VMI (which is deprecated) can live without it and you agree then I'll
> > cook up a patch to remove it altogether.
> 
> As Jeremy suggests we will be fine with disabling high ptes for VMI. 
> Thanks for doing this. 

OK, I'll do that.

Thanks,
Ian.


