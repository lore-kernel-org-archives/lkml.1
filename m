Return-Path: <linux-kernel-owner+w=401wt.eu-S1767825AbXCJFT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767825AbXCJFT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767828AbXCJFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:19:29 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:48632 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767825AbXCJFT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:19:28 -0500
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Valdis.Kletnieks@vt.edu
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
References: <1173419792.32234.131.camel@localhost.localdomain>
	 <1173481052.32234.137.camel@localhost.localdomain>
	 <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 16:19:28 +1100
Message-Id: <1173503968.3104.65.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-03-09 at 23:03 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 10 Mar 2007 09:57:32 +1100, Rusty Russell said:
> 
> > +/* GCC is awesome. */
> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
> >  	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
> >  		 typeof(&arr[0]))]))*0)
> 
> -/* GCC is awesome. */
> +/* GCC leaves me speechless. */

A speechless Rusty would be horrible. That said, it would be nice if the
comment was something more like the normal Rusty pearl of wisdom. I
understand the first part, but have no idea was + sizeof(typeof(int[....
does...

