Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXLNS4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXLNS4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbXLNSzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:55:53 -0500
Received: from [198.99.130.12] ([198.99.130.12]:42374 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbXLNSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:55:52 -0500
Date: Fri, 14 Dec 2007 13:55:11 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] UML - Add asm/fixmap.h include
Message-ID: <20071214185511.GA7852@c2.user-mode-linux.org>
References: <20071214161647.GA5802@c2.user-mode-linux.org> <20071214095840.28736204.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214095840.28736204.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 09:58:40AM -0800, Andrew Morton wrote:
> arch/um/include/um_uaccess.h already includes fixmap.h.  Is this a -mm-only
> fix?

Whoops, it is.  The include was removed by uml-header-untangling.patch,
so folding this into that would work.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
