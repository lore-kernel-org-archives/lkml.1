Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXGLTi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXGLTi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXGLTiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:38:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33054 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbXGLTiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:38:19 -0400
Date: Thu, 12 Jul 2007 21:38:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86 setup code rewrite in C - revised
Message-ID: <20070712193817.GA1255@one.firstfloor.org>
References: <1184181538674-git-send-email-hpa@zytor.com> <alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:24:48AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 11 Jul 2007, H. Peter Anvin wrote:
> >
> > This patch set replaces the x86 setup code, which is currently all in
> > assembly, with a version written in C, using the ".code16gcc" feature
> > of binutils (which has been present since at least 2001.)
> >
> >  76 files changed, 4606 insertions(+), 5209 deletions(-)
> 
> I can't really argue against this on any sane grounds - not only is it 
> removing more lines than it adds, but moving from mostly unreadable 
> assembly to C seems a good idea.

The only thing questionable is that .code16gcc is arguably quite
an abuse of gcc. I even checked with some gcc developers 
and they weren't too happy about it. e.g. it's not regression
tested at all so we would be basically on our own with it.

But yes the code looks good.

-Andi

