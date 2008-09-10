Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYIJXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYIJXPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYIJXPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:15:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYIJXPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:15:16 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080910.160505.14060698.davem@davemloft.net>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 16:15:11 -0700
Message-Id: <1221088512.13621.58.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 16:05 -0700, David Miller wrote:
> 
> Tell that to every Debian and Debian derived system on the planet.
> 
> To my knowledge, it is only fedora and possibly one or two other dists
> that put the firmware files in a unary /lib/firmware location, rather
> than a versioned /lib/firmware/$KERNELRELASE one.

So every time they upgrade from one kernel to the next, do they
automatically run b43-fwcutter again to make a new copy of the firmware,
for the new kernel?

Or if they use QLogic SCSI cards, do they download a new (but identical)
version of the firmware each time they upgrade their kernel?

It sounds like a daft arrangement to me -- although of course it's
possible for the packager to do whatever they like, by overriding
$(INSTALL_FW_PATH) in their package build.

It's definitely not something we should be doing upstream though.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

