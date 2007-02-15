Return-Path: <linux-kernel-owner+w=401wt.eu-S1030394AbXBOR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394AbXBOR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030396AbXBOR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:59:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030394AbXBOR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:59:19 -0500
Date: Thu, 15 Feb 2007 09:58:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tony.luck@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
In-Reply-To: <20070215085500.30e57866.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0702150957110.20368@woody.linux-foundation.org>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
 <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au>
 <20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com>
 <20070213144909.70943de2.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
 <20070215085500.30e57866.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Randy Dunlap wrote:
> 
> so, are we going to get a revert of 42da9cbd3eedde33a42acc2cb06f454814cf5de0 ?
> Has that been requested?  or are there other plans?

It should be fixed now (I had patches from Nick, but got sidetracked by 
trying to fix metacity for the gnome people). 

I've pushed out, but mirroring delays mean that unless you use 
master.kernel.org you'll need to wait a bit. I think Nick cc'd the kernel 
mailing list, though, so you can look for subjects containing "mincore" if 
you need it fixed before that.

		Linus
