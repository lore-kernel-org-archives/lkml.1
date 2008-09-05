Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYIEJtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYIEJtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYIEJth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:49:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:38358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYIEJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:49:36 -0400
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
From: David Woodhouse <dwmw2@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Khem Raj <raj.khem@gmail.com>
In-Reply-To: <1219172580.17033.87.camel@brick>
References: <1219106875.17033.55.camel@brick>
	 <20080819072715.GB30521@flint.arm.linux.org.uk>
	 <1219172580.17033.87.camel@brick>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 10:49:29 +0100
Message-Id: <1220608169.2985.305.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 12:03 -0700, Harvey Harrison wrote:
> include/linux/swab.h, include/linux/byteorder.h are in current
> mainline which is all that these patches depend on.

Er, it also depends on the patch which exports those headers to
userspace, which isn't in Linus' tree yet.

So merging this for ARM (between -rc4 and rc5!) has broken the exported
headers on ARM -- as noted by Khem.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



