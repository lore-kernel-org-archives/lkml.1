Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZKRNyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZKRNyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZKRNyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:54:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbZKRNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:54:09 -0500
Date: Wed, 18 Nov 2009 08:54:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-ID: <20091118135414.GA16218@infradead.org>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <OWmO9uyC1hM.A.yiC._ndALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OWmO9uyC1hM.A.yiC._ndALB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:01:19AM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).

FYI I see exactly the same symptoms - tons of probe timeouts, usually
very shortly after the association.  But I see this with an Intel 5100
AGN so it's either mac80211-related or coincidence.  I now went back to
2.6.31 which is perfectly fine for about half an hour.  I'll try to
bisect it down a bit, but many .32-rc releases hang on very early in
ACPI code on this box which might make it a pain or impossible.

