Return-Path: <linux-kernel-owner+w=401wt.eu-S940796AbXHIOvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940796AbXHIOvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937485AbXHIOux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:50:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936719AbXHIOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:50:52 -0400
Subject: Re: [PATCH] ld.so on FC7 is mmap'ing shared libraries right in
	over guest memory.
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ron minnich <rminnich@gmail.com>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1186657645.17752.60.camel@localhost.localdomain>
References: <1186657645.17752.60.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 09 Aug 2007 07:48:36 -0700
Message-Id: <1186670916.4521.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 21:07 +1000, Rusty Russell wrote:
> From: Ronald G. Minnich <rminnich@gmail.com>
> 
> [ FC7 maps shared libraries very low, where the launcher maps guest's
> physical memory.  Quick fix is to link Launcher static, real fix is for
> 2.6.24. ]
> 
> -static is a simple fix. I expect this problem will be more common than we
> like, as different distro's make different "improvements" to ld.so


this description is incorrect; it's not an ld.so change that causes the
low mapping.

It's a command line option to the prelink program (which is in most
distributions) that makes it use the entire address space, not just the
higher bits....



