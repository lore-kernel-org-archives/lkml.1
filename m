Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbXI1TES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbXI1TES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXI1TEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:04:12 -0400
Received: from [198.99.130.12] ([198.99.130.12]:41389 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXI1TEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:04:10 -0400
Date: Fri, 28 Sep 2007 15:03:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - Fix locking in skb alloction failure fix
Message-ID: <20070928190354.GA9000@c2.user-mode-linux.org>
References: <20070928154314.GA7185@c2.user-mode-linux.org> <20070928112634.0bef9525.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928112634.0bef9525.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:26:34AM -0700, Andrew Morton wrote:
> Doesn't this assume that the arch is only ever uniprocessor, which I
> don't think is true on i386 UML??

It is for now, and when that changes, I haven't decided if and when
interrupts will be received on multiple CPUs.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
