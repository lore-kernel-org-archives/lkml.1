Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZEVVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZEVVnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbZEVVn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:43:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42286 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756952AbZEVVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:43:27 -0400
Date: Fri, 22 May 2009 22:43:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090522224345.5b4d58eb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905221500390.5204@qirst.com>
References: <1242333519.15391.210.camel@nimitz>
	<alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	<1242335120.15391.242.camel@nimitz>
	<alpine.DEB.1.10.0905141729180.30187@qirst.com>
	<20090514213403.GB14741@elf.ucw.cz>
	<1242337299.28440.47.camel@nimitz>
	<20090515130547.GA1976@elf.ucw.cz>
	<alpine.DEB.1.10.0905151358430.26559@qirst.com>
	<20090515200213.GA1406@ucw.cz>
	<alpine.DEB.1.10.0905151713230.26489@qirst.com>
	<20090519203944.GD1362@ucw.cz>
	<alpine.DEB.1.10.0905221500390.5204@qirst.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 15:01:23 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> Subject: Remove misleading kernel log entries about "Out of Memory" conditions
> 
> What we traditionally call an "out of memory" failure is mostly not really
> related to having enough physical memory. "out of memory" occurs when the
> memory reclaim attempts fail to provide enough memory for an allocation.

That looks even more misleading. It now sounds like something you should
immediately rush out and file in bugzilla.

Not a good change at all
