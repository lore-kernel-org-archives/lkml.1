Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZDQAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZDQAxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZDQAxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:53:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086AbZDQAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:53:00 -0400
Date: Thu, 16 Apr 2009 17:46:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Message-ID: <alpine.LFD.2.00.0904161742140.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13098
> Subject		: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2009-04-06 01:14 (11 days old)
> References	: http://lkml.org/lkml/2009/4/5/200
> Handled-By	: H. Peter Anvin <hpa@zytor.com>

I think this got fixed already. The VGA moresettign was reverted back to 
the old order.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13044
> Subject		: 2.6.30-rc1 can't find the root fs
> Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> Date		: 2009-04-08 13:35 (9 days old)

This was one of the async things that got fixed by just waiting for module 
async work to finish.

		Linus
