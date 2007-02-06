Return-Path: <linux-kernel-owner+w=401wt.eu-S965005AbXBFQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005AbXBFQ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965017AbXBFQ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:26:33 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:32677 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965005AbXBFQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:26:32 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Tue, 6 Feb 2007 17:25:42 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Jan Beulich" <jbeulich@novell.com>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Message-ID: <20070206162542.GJ8665@alberich.amd.com>
References: <20070205171959.GF8665@alberich.amd.com>
 <200702061045.22966.ak@suse.de> <45C85E41.76E4.0078.0@novell.com>
 <200702061154.57621.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200702061154.57621.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 16:25:43.0571 (UTC)
 FILETIME=[72DFBE30:01C74A0B]
X-WSS-ID: 69D6739E2MC7247376-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 11:54:57AM +0100, Andi Kleen wrote:
> On Tuesday 06 February 2007 10:53, Jan Beulich wrote:
> > >> I don't think I remember a restriction here, at least not below 44 bits
> > >> (that's where pfn-s would need to become 64-bit wide).
> > >
> > >The i386 mm code only supports 4 entries in the PGD, so more than 36bit cannot 
> > >be mapped right now.
> > 
> > That has nothing to do with the number of physical address bits.
> 
> You couldn't use the memory in any ways.
> 
> Anyways I give up -- the check is probably not needed, unless Andreas
> comes up with a good reason.

No, I haven't a good reason to restrict the base address to fewer
than 44 bits.

So the question is, should I completely remove that check or adapt it
to check for 44 bit instead of 36 bit?


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



