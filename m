Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZLVTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZLVTpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZLVTpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:45:31 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:29842 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZLVTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:45:30 -0500
Date: Tue, 22 Dec 2009 14:45:11 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
In-reply-to: <4B307C4D.501@kernel.org>
Message-id: <alpine.LFD.2.00.0912221440440.5153@localhost.localdomain>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
 <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
 <alpine.LFD.2.00.0912212107560.5520@localhost.localdomain>
 <4B3035B0.9030303@kernel.org>
 <alpine.LFD.2.00.0912220253080.7435@localhost.localdomain>
 <4B307C4D.501@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Yinghai Lu wrote:

> Len Brown wrote:
> > 
> > Does 3563ff964fdc36358cef0330936fdac28e65142a work or fail on your system? 
> > I didn't ask about reverting it, I asked if it works or fails.
> 
> i don't know.
> 
> anything i should search in the bootlog?

Please check out a branch at the commit identified above
and tell us if the following issue:

"it seems these three patches broke the _OSC on my intel new systems."

"revert them fix the problem with AER and pciehp and etc"

is present or absent on that branch.

If the answer is yes, when stock 2.6.32 works, then the 3 patches
between that commit and 2.6.32 are at fault.  If the answer is no,
yet reverting those patches helps top of tree, then the issue must
be a merge conflict with other changes in 2.6.33.

thanks,
-Len Brown
Intel Open Source Technolgy Center

