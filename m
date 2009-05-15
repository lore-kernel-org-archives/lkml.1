Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZEOV6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZEOV6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZEOV6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:58:45 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36845 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753715AbZEOV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:58:44 -0400
Date: Fri, 15 May 2009 17:15:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pavel Machek <pavel@ucw.cz>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <20090515200213.GA1406@ucw.cz>
Message-ID: <alpine.DEB.1.10.0905151713230.26489@qirst.com>
References: <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com>
 <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Pavel Machek wrote:

> > Nope. If you have too little memory for your app then the kernel pages
> > portions of the app out to disk. Thats is why you have a VM (VIRTUAL
> > machine). The app is not running with physical memory.
>
> Try running your machine with mem=8M, then tell me how virtual memory
> works.

Well that is of course not enough memory. And you intentionally screwed up
your setup.

> If you have *way* too little RAM, you OOM. (Kernel data is
> unswappable. Task struct is 8KB. At some point it breaks).

I do not see anyone doubting that this is the case.

