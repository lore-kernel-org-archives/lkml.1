Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYIJXhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYIJXhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYIJXhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:37:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYIJXhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:37:01 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080910.162423.40167601.davem@davemloft.net>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 16:36:56 -0700
Message-Id: <1221089816.13621.61.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 16:24 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Wed, 10 Sep 2008 16:15:11 -0700
> 
> > It's definitely not something we should be doing upstream though.
> 
> So you think it's ok that every Debian user has to learn this
> magic incantation just to use current kernels?

They don't. Debian uses firmware from /lib/firmware if it doesn't exist
in /lib/firmware/$(version) -- so they can install to the normal
location quite happily, and it should work just fine.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

