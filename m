Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbXHXHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbXHXHFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760210AbXHXHFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:05:08 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:35686 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbXHXHFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:05:07 -0400
Date: Fri, 24 Aug 2007 09:01:20 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: john stultz <johnstul@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824090120.25ee709c@localhost>
In-Reply-To: <1187905306.6024.24.camel@localhost.localdomain>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
	<1187905306.6024.24.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 14:41:45 -0700
john stultz <johnstul@us.ibm.com> wrote:

> > My initial reaction would be to either ifdef ia64 implementation in
> > drivers/char/hpet.c or move the code under the ia64 arch dir until it is
> > really usable by all arches.  
> 
> Here is a possible quick fix. I'm open to other approaches, but I also
> want to avoid too much churn before 2.6.23 goes out.
> 
> Paolo, could you verify this fixes the issue for you?

It works: there's only one "hpet" in "available_clocksource" and also
the hard freeze using it seems gone.

:)

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g1a8f4610-dirty on x86_64
