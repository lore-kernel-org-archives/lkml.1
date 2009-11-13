Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZKMJil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZKMJil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZKMJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:38:36 -0500
Received: from www.tglx.de ([62.245.132.106]:58675 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZKMJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:38:35 -0500
Date: Fri, 13 Nov 2009 10:38:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan> <1258069232.14894.9.camel@localhost.localdomain> <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
 <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
> Yes. Yes. This is a hardware errata. I have a patch to workaround this and
> waiting on the errata description to get published..

Can we at least have some PCI quirk or whatever until you can push the
final workaround out so peoples machines do not explode ?

Thanks,

	tglx

