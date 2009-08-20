Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZHTH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZHTH4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZHTH4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:56:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZHTH4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:56:19 -0400
Subject: Re: [Bugme-new] [Bug 14003] New: Infinite loop on bootup while
 handling DMAR
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090819142634.0fc550d1.akpm@linux-foundation.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 08:52:28 +0100
Message-Id: <1250754748.8974.17.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 14:26 -0700, Andrew Morton wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=14003
> >            Summary: Infinite loop on bootup while handling DMAR
> 
> That's a box-killing post-2.6.30 regression.

It's a BIOS bug -- the user's BIOS is written by idiots who obviously
shipped it without any QA whatsoever.

As far as I can tell, 2.6.30 aborted early because of a _different_ BIOS
bug, but now we cope with that particular bug and we fall over the next
bug. Or just come across them in a different order.

The IOMMU on this board can _never_ have worked. Just disable it.

Or use a board with open source firmware available, and this kind of
crap won't happen. (At least if it does, you'll be able to fix it).

-- 
dwmw2

