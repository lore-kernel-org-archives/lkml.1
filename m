Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXA3SrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXA3SrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXA3SrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:47:04 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1850 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXA3SrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:47:03 -0500
Date: Tue, 30 Jan 2007 19:47:00 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070130184700.GA67320@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Len Brown <lenb@kernel.org>, Andi Kleen <ak@suse.de>
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070130090645.GC11823@dspnet.fr.eu.org> <20070130012631.8bb86c76.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130012631.8bb86c76.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:26:31AM -0800, Andrew Morton wrote:
> Len, what was in that merge anyway?  Lots of renaming and shuffling things
> around - the sorts of things which are safe as long as they compile OK.  But
> was there much substantive material in there as well?

It seems heavy in general, but the intersection with mmconfig looks
rather limited:
- s/acpi_table_mcfg_config/acpi_mcfg_allocation/
- s/base_address/address/
- s/pci_segment_group_number/pci_segment/
- address is now 64 bits

The last point is both good and bad.  The i965 needs it (good), I
don't know if the mapping functions can handle actual 64bits addresses
(maybe bad), especially on i386.

  OG.

