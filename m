Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZBJR6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZBJR6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBJR6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:58:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:23009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZBJR6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:58:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,187,1233561600"; 
   d="scan'208";a="429826879"
Subject: Re: 2.6.29-rc4-git1 -- iwl3945: Does not suspend/resume
	successfully.
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090210142337.GB3534@tuxdriver.com>
References: <a44ae5cd0902091844m48a48e01i5c8d567279d70dff@mail.gmail.com>
	 <20090210142337.GB3534@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 10:02:05 -0800
Message-Id: <1234288925.11530.175.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 06:23 -0800, John W. Linville wrote:
> On Mon, Feb 09, 2009 at 09:44:27PM -0500, Miles Lane wrote:
> 
> > At resume:
> > 
> > [ 2619.951641] iwl3945 0000:03:00.0: PCI INT A disabled
> > [ 2619.954113] wlan0: disassociating by local choice (reason=3)
> > [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> > 0xf (was 0x100, writing 0x10b)
> > [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> > 0x4 (was 0x0, writing 0xd6000000)
> > [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> > 0x3 (was 0x0, writing 0x10)
> > [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> > 0x1 (was 0x100000, writing 0x100102)
> > [ 2627.612291] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > [ 2627.612646] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> > [ 2629.644532] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> > [ 2629.644669] iwl3945 0000:03:00.0: PCI INT A disabled
> > [ 2629.655349] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > [ 2629.655752] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> > [ 2631.684143] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> > [ 2631.684281] iwl3945 0000:03:00.0: PCI INT A disabled
> > [ 2701.336116] Hangcheck: hangcheck value past margin!
> > 
> > Result:  The device isn't responding to Network Manager (no APs listed).
> 
> Is this a dup?
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=12656
> 
> Reinette, should I revert that patch?  Or is there a fix coming?

This does look like a duplicate. Fix coming. 


Reinette

