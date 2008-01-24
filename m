Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYAYHoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYAYHoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759694AbYAYHTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:19:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2190 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759665AbYAYHTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:19:37 -0500
Date: Thu, 24 Jan 2008 17:22:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]PCIE ASPM support - takes 3
Message-ID: <20080124172258.GA5447@ucw.cz>
References: <1200621388.8965.3.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200621388.8965.3.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> v3->v2, fixed the issues Matthew Wilcox raised.
> 
> PCI Express ASPM defines a protocol for PCI Express components in the D0
> state to reduce Link power by placing their Links into a low power state
> and instructing the other end of the Link to do likewise. This
> capability allows hardware-autonomous, dynamic Link power reduction
> beyond what is achievable by software-only controlled power management.
> However, The device should be configured by software appropriately.
> Enabling ASPM will save power, but will introduce device latency.

How big is the latency? 1msec? 10msec? 100usec?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
