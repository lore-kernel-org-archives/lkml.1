Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXFVQHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXFVQHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbXFVQGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:06:51 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50760 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbXFVQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:06:49 -0400
X-IronPort-AV: i="4.16,452,1175497200"; 
   d="scan'208"; a="170322267:sNHT47737107"
To: trenn@suse.de
Cc: Tim Gardner <tim.gardner@canonical.com>,
       Thomas Gleixner <tglx@linutronix.de>, Chuck Ebbert <cebbert@redhat.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: ACPI Regression on Dell E1501
X-Message-Flag: Warning: May contain useful information
References: <467AE7E1.4050805@canonical.com> <467AF204.3060805@redhat.com>
	<1182462902.3316.105.camel@chaos> <467BC9F8.5000403@canonical.com>
	<467BCC3F.4080405@canonical.com>
	<1182525150.28514.746.camel@queen.suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 22 Jun 2007 09:06:47 -0700
In-Reply-To: <1182525150.28514.746.camel@queen.suse.de> (Thomas Renninger's message of "Fri, 22 Jun 2007 17:12:30 +0200")
Message-ID: <adair9g2ctk.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jun 2007 16:06:47.0833 (UTC) FILETIME=[5619E090:01C7B4E7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > pci=nomsi let the machine still boot.
 > 
 > I tried a bit and I think I got it, for me it's this one:
 > 
 > commit 78b7611c4a1e3ff008abc4751b566cb533d68f3d

Really??  That's "msi: mask the msix vector before we unmap it" and
A) it looks *really* obviously correct and B) it should only have an
effect if a driver using MSI-X releases an IRQ.

What testing did you do to pick out that change?  Does your system
work OK with just that patch reverted?

 - R.
