Return-Path: <linux-kernel-owner+w=401wt.eu-S934311AbXFFAqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311AbXFFAqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbXFFAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:46:24 -0400
Received: from [198.99.130.12] ([198.99.130.12]:54093 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbXFFAqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:46:23 -0400
Date: Tue, 5 Jun 2007 20:37:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-ID: <20070606003752.GA11511@c2.user-mode-linux.org>
References: <20070605205055.GA9770@c2.user-mode-linux.org> <20070605170001.c8b2110e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605170001.c8b2110e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 05:00:01PM -0700, Andrew Morton wrote:
> On Tue, 5 Jun 2007 16:50:55 -0400
> Jeff Dike <jdike@addtoit.com> wrote:
> 
> > [ This is 2.6.22 material ]
> > 
> > Having KERNEL_STACK_ORDER in defconfig overrides the value provided by
> > Kconfig, breaking UML/x86_64, which wants 2 page stacks.

> That means the Kconfig rules are wrong, surely?

I'm far from a Kconfig expert, but what I have is

config KERNEL_STACK_ORDER
	int "Kernel stack size order"
	default 1 if 64BIT
	default 0 if !64BIT

which seems reasonably clear and simple...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
