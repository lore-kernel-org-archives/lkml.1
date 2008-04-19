Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYDSJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYDSJvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYDSJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:51:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58357 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYDSJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:51:09 -0400
Date: Sat, 19 Apr 2008 18:50:46 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH][trivial] mm/pagewalk.c break const constraint.
Cc: kosaki.motohiro@jp.fujitsu.com, "Matt Mackall" <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <19f34abd0804190234m190f7ec4ga2a652029a83bab6@mail.gmail.com>
References: <20080419181759.A8EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <19f34abd0804190234m190f7ec4ga2a652029a83bab6@mail.gmail.com>
Message-Id: <20080419184918.A8EE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> >  when compile 2.6.25, following warnings was outputed.
> >
> >   CC      mm/pagewalk.o
> >  mm/pagewalk.c: In function 'walk_page_range':
> >  mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
> >  ointer target type
> >
> >  mm argument of walk_page_range() is unnecessary const restriction.
> >  this patch is no functional change. it's only remove warning.
> 
> Is this ia64 or cris? 

Yes, I use IA64.

> I think the correct way to resolve this is to
> make pgd_offset() take a const struct mm_struct * instead.

that makes sense.
OK, I will make patch again.

Thank you for very good opinion.



