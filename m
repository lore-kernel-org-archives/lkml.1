Return-Path: <linux-kernel-owner+w=401wt.eu-S1031600AbXEAJAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031600AbXEAJAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031602AbXEAJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:00:38 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:33460 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031600AbXEAJAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:00:36 -0400
Date: Tue, 1 May 2007 11:00:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
In-Reply-To: <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705011058330.27246@anakin>
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com>
 <20070430091121.GC31397@infradead.org> <20070430100917.439ebfc8.akpm@linux-foundation.org>
 <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Satyam Sharma wrote:
> Actually, the latter style (one condition per line and the && or ||
> operators appearing _before_ the conditions in subsequent lines)
> is quite popular for multi-line compound conditions (well, I've seen this
> in kernel/workqueue.c, kernel/stop_machine.c, etc at least, and also in
> Linus' code, if I'm not mistaken). We also align subsequent lines to the
> column of the condition belonging to the same "logical level" on the
> previous line using _spaces_ (note that this is alignment, not indentation,
> using spaces). The rationale is to make the operator prominent and thus make
> the structure of a complex multi-line compound conditional expression more
> readable and obvious at first glance itself. For example, consider:
> 
> 	if (veryverylengthycondition1 &&
> 		smallcond2 &&
> 		(conditionnumber3a ||
> 		condition3b)) {
> 		...
> 	}
> 
> versus
> 
> 	if (veryverylengthycondition1
> 	    && smallcond2
> 	    && (conditionnumber3a
> 	        || condition3b)) {
> 		...
> 	}
> 
> ?
> 
> Latter wins, doesn't it?

... because you forgot to align subsequent lines to the column of the
condition belonging to the same "logical level" on the previous line.

Consider this:

	if (veryverylengthycondition1 &&
	    smallcond2 &&
	    (conditionnumber3a ||
	     condition3b)) {
		...
	}

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
