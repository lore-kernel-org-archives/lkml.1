Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZEOS3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZEOS3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZEOS3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:29:23 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45009 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756280AbZEOS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:29:22 -0400
Date: Fri, 15 May 2009 13:59:50 -0400 (EDT)
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
In-Reply-To: <20090515130547.GA1976@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0905151358430.26559@qirst.com>
References: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz>
 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Pavel Machek wrote:

> Ok, so kernel should be fixed to make limits 30% of non-mlocked
> memory.

There is already ulimit.

> > folks.  They go sucking up and locking as much memory as they can get
> > their hands on.  Adding memory never helps them because they'll use up
> > whatever is there.
>
> Well, but it is uncommon everywhere else. If you have desktop system,
> job size is pretty much constant. If you have too little memory, you
> OOM.

Nope. If you have too little memory for your app then the kernel pages
portions of the app out to disk. Thats is why you have a VM (VIRTUAL
machine). The app is not running with physical memory.


