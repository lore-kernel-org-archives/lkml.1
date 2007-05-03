Return-Path: <linux-kernel-owner+w=401wt.eu-S1161970AbXECOTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161970AbXECOTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161972AbXECOTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:19:00 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46620 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161970AbXECOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:18:59 -0400
Date: Thu, 3 May 2007 10:14:05 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - forgot asm-um/cmpxchg.h
Message-ID: <20070503141405.GA5522@c2.user-mode-linux.org>
References: <20070501193646.GA9482@c2.user-mode-linux.org> <20070502230919.cb6864df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502230919.cb6864df.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:09:19PM -0700, Andrew Morton wrote:
> OK, I clumped all three patches into one as I think that's required for
> git-bisect friendliness.

OK - I separated the i386 and x86_64 bits to make it easy to drop the
x86_64 part.

Plus, I think it doesn't make any difference - the headers behave the
same as seen from the outside, except that UML needs the uml-cmpxchg
patch in order to build.  So, putting that first, then the other two
separately results in a patchset that builds at all stages, I believe.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
