Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYIAPsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYIAPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYIAPsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:48:21 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57624 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYIAPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:48:21 -0400
Date: Mon, 1 Sep 2008 11:47:43 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jiayingz@google.com,
       dkegel@google.com
Subject: Re: [PATCH 1/6] base: Valgrind headers and Kconfig
Message-ID: <20080901154743.GA7584@c2.user-mode-linux.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291613420.15543@abydos.NerdBox.Net> <87ljycxldb.fsf@basil.nowhere.org> <20080901140618.GA5691@c2.user-mode-linux.org> <20080901142219.GH18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901142219.GH18288@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 04:22:19PM +0200, Andi Kleen wrote:
> > Kernel code can't get headers from the system, unless you're thinking
> >        #include "/usr/include/valgrind.h"
> > or something similar.
> 
> Some um files at least least include sys/* files which are surely
> user space?  If they can include that why not valgrind.h? 

The userspace side of UML can (and, indeed must) use the system
headers.  Here, we can just #include <valgrind.h>.

However, the kernel side of UML, where the allocator annotations are,
can't use system headers.  The kernel side of things has to be
self-contained within the kernel tree.

	       	      	  	 Jeff

-- 
Work email - jdike at linux dot intel dot com
