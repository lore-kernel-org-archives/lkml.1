Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYKHDaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYKHDaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYKHD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:29:59 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:46726 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYKHD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:29:58 -0500
Date: Fri, 07 Nov 2008 22:29:53 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
In-reply-to: <200810281922.20490.arvidjaar@mail.ru>
X-X-Sender: lenb@localhost.localdomain
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>,
       toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0811072224200.9051@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200809061108.34877.arvidjaar@mail.ru>
 <200810281426.53499.trenn@suse.de> <200810281615.19894.rjw@sisk.pl>
 <200810281922.20490.arvidjaar@mail.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Do you have a pointer to those patches?
> > 
> 
> So far I am running with these commits from git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6:
> 
> commit f43d728731c691772ddc29e50d25c68a859935b5
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Fri Aug 1 17:37:55 2008 +0200
> 
>     Check for ACPI backlight support otherwise use vendor ACPI drivers
> 
> 
> commit ad9ed8385ed6ec5be8da7094db911c824258ceec
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Fri Aug 1 17:37:54 2008 +0200
> 
>     ACPI: video: Ignore devices that aren't present in hardware
> 
> I have been waiting for in-tree inclusion to submit patches for
> toshiba_acpi against stable base.

Ah, the commit id's above solved the mystery.
It looks like andi checked these patches directly into his
"test" branch rather than a topic branch.  eg. they were
sitting on top of the old pcc_acpi driver etc.

So I lost them when I deleted the old test branch
in order to merge the updated topic branches
into a new test branch.

-Len

