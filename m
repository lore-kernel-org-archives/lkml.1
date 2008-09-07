Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYIGIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYIGIUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIGIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 04:20:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:57969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYIGIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 04:20:31 -0400
Subject: Re: [PATCH] Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20080906154935.GD1774@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org>
	 <1220518477.2985.163.camel@pmac.infradead.org>
	 <20080905183459.GC14258@elte.hu>
	 <1220640430.2985.389.camel@pmac.infradead.org>
	 <20080906154935.GD1774@elte.hu>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 09:20:18 +0100
Message-Id: <1220775618.2985.408.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 17:49 +0200, Ingo Molnar wrote:
> Jesse's call obviously, but the DMI thing local to intel-iommu.c still 
> looks better to me in all regards. I'm no fan of DMI in general - it 
> just doesnt scale - but here a crappy BIOS gets punished with a DMI 
> quirk and that's OK.

The DMI was my first choice too -- I was only trying to do it with PCI
to keep Andi happy.

There is a non-zero possibility that the same BIOS bug gets copied to
other boards, I suppose -- but it's not exactly hard to add another
board to the table if we find that to be the case.

Shall I resubmit the original version to Linus again for 2.6.27, then?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



