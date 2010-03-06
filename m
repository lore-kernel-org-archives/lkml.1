Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0CFTuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:50:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab0CFTuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:50:44 -0500
Date: Sat, 6 Mar 2010 11:50:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH v2 0/7] resource, PNPACPI: add bus number and window
 support
In-Reply-To: <20100305174656.21946.93874.stgit@bob.kio>
Message-ID: <alpine.LFD.2.00.1003061145260.31447@localhost.localdomain>
References: <20100305174656.21946.93874.stgit@bob.kio>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I have nothing against this patch-series, but I'm not really much of a 
pnp person, so I'd like to see this at a minimum being acked by people who 
are, and who would use this. 

In fact, since the primary _reason_ for this seems to be to improve on the 
_CRS parsing code for PCI, I'd have expected that the people involved 
with previous _CRS issues be involved, and perhaps this whole thing could 
go through the PCI tree? But Yinghai Lu and Jesse Barnes weren't even 
cc'd. 

But maybe this really is more of an ACPI issue. I dunno. I get the feeling 
that ACPI doesn't really care, though - the subsystem that actually gets 
_affected_ by all this in the end is PCI.

Anyway, more acks, please. And preferably involve the PCI people too.

			Linus
