Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbXBFBKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbXBFBKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXBFBKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:10:18 -0500
Received: from thunk.org ([69.25.196.29]:58099 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965415AbXBFBKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:10:17 -0500
Date: Mon, 5 Feb 2007 20:09:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206010958.GA31809@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170717694.29759.941.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 11:21:34PM +0000, David Woodhouse wrote:
> But Alan makes a reasonable suggestion -- we could work around this in
> the tools too. 

I wouldn't call it "work around this" in the tools.  It's a useful
feature we can add in the tools for developers who aren't men enough
to use "sed/grep" pipelines.  :-)

But I have to agree with Linus here that we should be optimizing the
tools for people who know how to compile the kernel, but who aren't
necessarily familiar with all of the hidden dependencies in the
literally hundreds of config options in the kernel tree.  In reality,
you want to make it easy to turn on *or* off any arbitrary config
option, and to understand what you need to do so you can turn an
arbitrary config option on or off.  If that means tools enhancements,
so be it.  
						- Ted
