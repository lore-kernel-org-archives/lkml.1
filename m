Return-Path: <linux-kernel-owner+w=401wt.eu-S1030550AbXBFXQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030550AbXBFXQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030559AbXBFXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:16:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030550AbXBFXQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:16:08 -0500
Date: Tue, 6 Feb 2007 15:15:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <Pine.LNX.4.64.0702061505400.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702061513550.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <1170710272.29759.894.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
 <1170711587.29759.909.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
 <1170712393.29759.925.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
 <20070205143110.fca62b57.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
 <1170717694.29759.941.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
 <1170755101.29759.960.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
 <1170801484.29759.1000.camel@pmac.infradead.org> <20070206143956.b09c674d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702061505400.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, Linus Torvalds wrote:
> 
> On Tue, 6 Feb 2007, Randy Dunlap wrote:
> > 
> > Yes, that's the solution that I decided on during lunch also:
> > 	select <==> depends on
> 
> I think yuou can certainly enable an "expert mode", which just reads 
> "select" as "depends on".

Actually, it's probably more useful if you do it for a single symbol only.

If you really want to force something off, mark that *single* symbol as 
having "select <that-symbol>" being translated into "depends on", and it 
will probably work fine in practice.

		Linus
