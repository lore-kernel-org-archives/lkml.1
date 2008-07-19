Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYGSTOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYGSTOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYGSTOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:14:40 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:39256 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751326AbYGSTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:14:40 -0400
Date: Sat, 19 Jul 2008 15:14:38 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080719191438.GA19759@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807191026.03172.jbarnes@virtuousgeek.org> <20080719184011.GA19548@bromo.msbb.uc.edu> <200807191204.48428.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191204.48428.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 12:04:48PM -0700, Jesse Barnes wrote:
> On Saturday, July 19, 2008 11:40 am Jack Howarth wrote:
> > Jesse,
> >     It seems that MacBook Pro users aren't the only ones suffering from
> > PCIE_ASPM...
> >
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/cc1b8b3ef6
> >4e3257/dd4e427510bde7f0?lnk=raot
> >
> > I also discovered the pcie_noaspm kernel option from that thread which
> > allows me to boot the kernels built with PCIE_ASPM support by disabling
> > that feature.
> 
> Yeah, that's a good data point.  Thanks.  Sounds like there may also be some 
> ACPI interaction going on...
> 
> Jesse

Jesse,
   For what its worth, acpi=off alone is insufficent to inhibit the
kernel freezes when PCIE aspm is in use.
                  Jack
