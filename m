Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZB1Xdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZB1Xdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZB1Xdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:33:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZB1Xdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:33:32 -0500
Date: Sun, 1 Mar 2009 00:52:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
Message-ID: <20090228235201.GE26292@one.firstfloor.org>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <20090227210856.GB1476@ucw.cz> <20090228165624.GC26292@one.firstfloor.org> <20090228220829.GE21230@elf.ucw.cz> <87wsba1a9f.fsf@basil.nowhere.org> <20090228221944.GG21230@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228221944.GG21230@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So using aliases for kernel text rewriting is bad idea because it
> would break ia64?

Nope.

First what you do on x86 kernels doesn't matter to ia64.
And then kernel text rewriting doesn't require any illegal aliases anyways.
It would only be a problem if someone set the kernel text uncached,
which no sane person would do.

> That was what the thread was about. (Sorry, no ia64
> or sparc manuals nearby).

google knows them all.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
