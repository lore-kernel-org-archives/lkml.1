Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752609AbYLRGHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYLRGHc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYLRGHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:07:15 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:59949 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYLRGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:07:13 -0500
Date: Thu, 18 Dec 2008 01:07:08 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: acpi_os_allocate(GFP_KERNEL) (was Re: acpi_evaluate_integer broken
 by design)
In-reply-to: <200812170040.07977.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Message-id: <alpine.LFD.2.00.0812180104500.17738@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081125110508.GA1943@elf.ucw.cz>
 <20081215214140.9031d4c8.akpm@linux-foundation.org>
 <200812161634.25838.rjw@sisk.pl> <200812170040.07977.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-- Len Brown, Intel Open Source Technology Center

> In fact, we should be using GFP_ATOMIC already while devices are being
> suspended, so we can switch from GFP_KERNEL to GFP_ATOMIC even before
> interrupts are enabled.

true.  it makes me wonder if tinkering with ACPI
is a bad idea -- for it will address only one user of kmalloc.
