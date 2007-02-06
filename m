Return-Path: <linux-kernel-owner+w=401wt.eu-S964860AbXBFQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbXBFQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbXBFQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:16:41 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:47458 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964860AbXBFQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:16:39 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Tue, 6 Feb 2007 17:16:24 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Jan Beulich" <jbeulich@novell.com>
cc: "Andi Kleen" <ak@suse.de>, "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Message-ID: <20070206161624.GI8665@alberich.amd.com>
References: <20070205171959.GF8665@alberich.amd.com>
 <20070205145055.A19581@unix-os.sc.intel.com>
 <200702060853.30812.ak@suse.de> <45C85911.76E4.0078.0@novell.com>
MIME-Version: 1.0
In-Reply-To: <45C85911.76E4.0078.0@novell.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 16:16:26.0349 (UTC)
 FILETIME=[26BE69D0:01C74A0A]
X-WSS-ID: 69D676572KW7165502-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:31:45AM +0000, Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 06.02.07 08:53 >>>
> >On Monday 05 February 2007 23:50, Siddha, Suresh B wrote:
> >> On Mon, Feb 05, 2007 at 06:19:59PM +0100, Andreas Herrmann wrote:
> >> > o added check to restrict base address to 36 bit on i386
> >> 
> >> Why is this? It can go upto implemented physical bits, right?
> >
> >In theory it can, but Linux doesn't support it.
> 
> I don't think I remember a restriction here, at least not below 44 bits
> (that's where pfn-s would need to become 64-bit wide).
> 
> Jan
> 

Hi all,

shame on me.
Wanted to fix and interface issue where base address is truncated
at 44 bit in mtrr_write().

(And just thought 36 bit would be more than enough for that 32 bit
Linux version :)


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



