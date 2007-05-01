Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXEAPIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXEAPIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXEAPIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:08:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63307 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXEAPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:08:24 -0400
Date: Tue, 1 May 2007 08:05:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
Message-Id: <20070501080544.459a6ec9.randy.dunlap@oracle.com>
In-Reply-To: <1178028973.2875.78.camel@pmac.infradead.org>
References: <20061127165138.GA2991@lst.de>
	<20070430040213.BF9901801A4@magilla.sf.frob.com>
	<20070430091121.GC31397@infradead.org>
	<20070430100917.439ebfc8.akpm@linux-foundation.org>
	<a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	<Pine.LNX.4.64.0705011058330.27246@anakin>
	<1178028973.2875.78.camel@pmac.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 15:16:13 +0100 David Woodhouse wrote:

> On Tue, 2007-05-01 at 11:00 +0200, Geert Uytterhoeven wrote:
> > 
> >         if (veryverylengthycondition1 &&
> >             smallcond2 &&
> >             (conditionnumber3a ||
> >              condition3b)) {
> >                 ...
> >         }
> 
> It's horrid. I'd much rather see
> 
>         if (veryverylengthycondition1 &&
>             smallcond2 &&
>             (conditionnumber3a || condition3b)) {
>                 ...
>         }
> 
> Even if that does take it over 80 columns, the 'failure' mode will be
> that it gets wrapped round to the beginning of the screen or truncated
> at 80 columns -- and for the _majority_ of the time, it doesn't matter.
> 
> Unless you're paying particular attention to the logic and debugging the
> statement, a 'high-level' view of what's going on is perfectly
> sufficient; you don't actually read every character anyway.

I prefer this format also, but I'm not sure that we can get it
into CodingStyle.  CodingStyle is about (either) concensus or
dictum, but I don't see us close to concensus...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
