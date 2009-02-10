Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZBJObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZBJObS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZBJObD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:31:03 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37829 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZBJObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:31:01 -0500
Date: Tue, 10 Feb 2009 09:23:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc4-git1 -- iwl3945: Does not suspend/resume
	successfully.
Message-ID: <20090210142337.GB3534@tuxdriver.com>
References: <a44ae5cd0902091844m48a48e01i5c8d567279d70dff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0902091844m48a48e01i5c8d567279d70dff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 09:44:27PM -0500, Miles Lane wrote:

> At resume:
> 
> [ 2619.951641] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2619.954113] wlan0: disassociating by local choice (reason=3)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0xf (was 0x100, writing 0x10b)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x4 (was 0x0, writing 0xd6000000)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x3 (was 0x0, writing 0x10)
> [ 2623.178462] iwl3945 0000:03:00.0: restoring config space at offset
> 0x1 (was 0x100000, writing 0x100102)
> [ 2627.612291] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 2627.612646] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> [ 2629.644532] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> [ 2629.644669] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2629.655349] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 2629.655752] iwl3945 0000:03:00.0: irq 28 for MSI/MSI-X
> [ 2631.684143] iwl3945: Wait for START_ALIVE timeout after 2000ms.
> [ 2631.684281] iwl3945 0000:03:00.0: PCI INT A disabled
> [ 2701.336116] Hangcheck: hangcheck value past margin!
> 
> Result:  The device isn't responding to Network Manager (no APs listed).

Is this a dup?

	http://bugzilla.kernel.org/show_bug.cgi?id=12656

Reinette, should I revert that patch?  Or is there a fix coming?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
