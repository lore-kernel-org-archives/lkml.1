Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZHBVPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZHBVPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZHBVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:15:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbZHBVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:15:04 -0400
Date: Sun, 2 Aug 2009 14:14:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <200908022216.10681.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0908021410420.3352@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <200908022216.10681.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:
> 
> It works, ie. with this patch applied the PCI resources on the nx6325 look
> exactly like with commit  a76117dfd687ec4be0a9a05214f3009cc5f73a42 reverted.

Ok, I'll commit it.

This leaves the issue of the serial ports on ia64 open. So it may be that 
we'll have to instead revert the use of pci_claim_resource() on x86, but 
it sounded like we'd have people looking at that. I'd rather make forward 
progress on something that looks this trivial than revert it just to get 
us back to the pre-regression thing.

			Linus
