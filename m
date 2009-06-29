Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZF2Pj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZF2Pj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZF2Pjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:39:49 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:44117 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZF2Pjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:39:48 -0400
Date: Mon, 29 Jun 2009 11:39:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Corentin Chary <corentincj@iksaif.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH, v3] eeepc-laptop: Fix build failure with HOTPLUG_PCI &&
 !SYSFS (was: [git pull request] ACPI & driver patches for 2.6.31-rc1)
In-reply-to: <20090629081339.GA321@elte.hu>
Message-id: <alpine.LFD.2.00.0906291135550.5716@localhost.localdomain>
References: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain>
 <20090629080754.GA28336@elte.hu> <20090629081016.GA31398@elte.hu>
 <20090629081339.GA321@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing this config, Ingo.

I agree, our build system can handle "depends",
but "select" does not deliver on what it advertises,
making it a trap for programmers.

Acked-by: Len Brown <len.bron@intel.com>

thanks,
Len Brown, Intel Open Source Technology Center

