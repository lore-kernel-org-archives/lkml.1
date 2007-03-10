Return-Path: <linux-kernel-owner+w=401wt.eu-S1767809AbXCJE0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767809AbXCJE0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767811AbXCJE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:26:20 -0500
Received: from xenotime.net ([66.160.160.81]:44677 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1767809AbXCJE0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:26:19 -0500
Date: Fri, 9 Mar 2007 20:24:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Valdis.Kletnieks@vt.edu
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-Id: <20070309202442.c6b1a64d.rdunlap@xenotime.net>
In-Reply-To: <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
References: <1173419792.32234.131.camel@localhost.localdomain>
	<1173481052.32234.137.camel@localhost.localdomain>
	<200703100403.l2A4355v008616@turing-police.cc.vt.edu>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Mar 2007 23:03:05 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Sat, 10 Mar 2007 09:57:32 +1100, Rusty Russell said:
> 
> > +/* GCC is awesome. */
> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
> >  	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
> >  		 typeof(&arr[0]))]))*0)
> 
> -/* GCC is awesome. */
> +/* GCC leaves me speechless. */

"awesome" can mean "inspiring awe or admiration or wonder" (amazing)
or it can mean "awful" (as in terrifying).  8)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
