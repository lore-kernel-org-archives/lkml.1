Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZKMScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZKMScp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZKMSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:32:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:2434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZKMSck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:32:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,738,1249282800"; 
   d="scan'208";a="569306772"
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>
	 <20091111195016.GB22225@redhat.com>
	 <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>
	 <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>
	 <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
	 <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>
	 <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan>
	 <1258069232.14894.9.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
	 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
	 <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
	 <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 10:32:45 -0800
Message-Id: <1258137165.21141.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
> > Yes. Yes. This is a hardware errata. I have a patch to workaround this and
> > waiting on the errata description to get published..
> 
> Can we at least have some PCI quirk or whatever until you can push the
> final workaround out so peoples machines do not explode ?

Its a harmless bug functionality-wise and should not have any side
effect other than triggering the WARN_ON_ONCE in hpet next event code.

Thanks,
Venki

