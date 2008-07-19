Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYGSSkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYGSSkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 14:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYGSSkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 14:40:14 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:35286 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752292AbYGSSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 14:40:13 -0400
Date: Sat, 19 Jul 2008 14:40:11 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080719184011.GA19548@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080719051227.GA10044@bromo.msbb.uc.edu> <86802c440807182228u5259eba1x238ec3af5fc4324c@mail.gmail.com> <200807191026.03172.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191026.03172.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
    It seems that MacBook Pro users aren't the only ones suffering from
PCIE_ASPM...

http://groups.google.com/group/linux.kernel/browse_thread/thread/cc1b8b3ef64e3257/dd4e427510bde7f0?lnk=raot

I also discovered the pcie_noaspm kernel option from that thread which
allows me to boot the kernels built with PCIE_ASPM support by disabling
that feature.
                   Jack
