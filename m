Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYH0Gf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYH0Gf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYH0Gfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:35:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:47818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYH0Gfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:35:36 -0400
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: David Woodhouse <dwmw2@infradead.org>
To: Tim Anderson <tanderson@mvista.com>
Cc: dedekind@infradead.org, Bruce_Leonard@selinc.com,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-mtd-bounces@lists.infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, "'Bruce Leonard'" <brucle@earthlink.net>
In-Reply-To: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
References: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 07:35:23 +0100
Message-Id: <1219818923.7107.106.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 23:20 -0700, Tim Anderson wrote:
> I see your point. Ioctls are going away after all.
> 
> So we should have something like:
> /sys/class/mtd/mtd0/
> 
> Or just under device or platform? 

Tim, please stop top-posting.

I'm not sure I'd say I _vetoed_ new ioctls, but I certainly expressed a
desire to do all the information stuff through sysfs. We would need a
new MEMERASE64 ioctl though.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



