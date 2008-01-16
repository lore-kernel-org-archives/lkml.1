Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYAPFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYAPFZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 00:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYAPFZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 00:25:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:18549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYAPFZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 00:25:29 -0500
X-ExtLoop1: 1
Subject: Re: [PATCH]PCIE ASPM support - takes 2
From: Shaohua Li <shaohua.li@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
In-Reply-To: <24456.1200455812@turing-police.cc.vt.edu>
References: <1200373346.20739.4.camel@sli10-desk.sh.intel.com>
	 <24456.1200455812@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 13:26:14 +0800
Message-Id: <1200461174.26885.4.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 22:56 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 15 Jan 2008 13:02:26 +0800, Shaohua Li said:
> 
> > In my test, power difference between powersave mode and performance mode
> > is about 1.3w in a system with 3 PCIE links.
> 
> Do you have any numbers on what the added latency is for powersave mode, and
> a rough idea of how quickly chipsets will drop to low-power? It may affect
> usability a lot if it's "adds 10ms latency after 100ms idle" or "adds 100ms
> latency after 5 seconds idle" or some other pattern...
> 
> (The chipset in my laptop claims to be an 82801G with 4 PCI-Express ports on
> it - I'm trying to get a rough idea what usage I'd get out of that feature..)
No, I thought to get the latency impact with ASPM enabled, but haven't
found a way to measure it. This is why the default setting of ASPM
currently is using BIOS setting.

Thanks,
Shaohua

