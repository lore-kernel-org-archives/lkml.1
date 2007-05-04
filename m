Return-Path: <linux-kernel-owner+w=401wt.eu-S1766609AbXEDTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766609AbXEDTnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161919AbXEDTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:43:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161918AbXEDTnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:43:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/utrace
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move sig_kernel_* et al macros to linux/signal.h
In-Reply-To: Andrew Morton's message of  Friday, 4 May 2007 01:10:03 -0700 <20070504011003.113b1580.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070504194308.F35C71800A0@magilla.sf.frob.com>
Date: Fri,  4 May 2007 12:43:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Should we undef rt_sigmask and siginmask after using them here?

They are used in macros, so "after" using them doesn't happen inside the file.
To do this sig_kernel_* would have to be redefined as inlines.
That should be fine AFAIK, but I hadn't intended to perturb it like that.


Thanks,
Roland
