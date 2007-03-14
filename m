Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbXCNS5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbXCNS5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXCNS5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:57:23 -0400
Received: from gw.goop.org ([64.81.55.164]:48952 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbXCNS5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:57:23 -0400
Message-ID: <45F8458B.5090309@goop.org>
Date: Wed, 14 Mar 2007 11:57:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <1173875708.31159.17.camel@localhost.localdomain> <20070314130531.GA27498@one.firstfloor.org> <1173879395.31159.33.camel@localhost.localdomain> <20070314184744.GA376@one.firstfloor.org>
In-Reply-To: <20070314184744.GA376@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Only do it where it makes sense and is not too intrusive.
> Redoing the whole port just for lguest64 is probably not a good idea.

Well, at some point Xen is going to be 64-bit.  We need a 64-bit
paravirt_ops, and it looks to me that 90% of the entrypoints will be
more or less identical for 32 and 64 bit x86, so it would be unfortunate
to not share it.

The existing technique for sharing stuff between 32 and 64 bits is
pretty damn ugly, and I think Steven is on to something with this
patch.  Though I'm definitely sympathetic to the concern that it will
break a pile of outstanding patches.

    J

