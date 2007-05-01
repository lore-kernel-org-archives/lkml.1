Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXEAQNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXEAQNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXEAQNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:13:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbXEAQNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:13:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com> 
References: <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com>  <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430091121.GC31397@infradead.org> <20070430100917.439ebfc8.akpm@linux-foundation.org> <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com> <Pine.LNX.4.64.0705011058330.27246@anakin> <1178028973.2875.78.camel@pmac.infradead.org> 
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 01 May 2007 17:07:07 +0100
Message-ID: <9185.1178035627@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:

> 	if (veryverylengthycondition1
> 		&& smallcond2
> 		&& (conditionnumber3a
> 			|| condition3b)) {
> 		...
> 	}
> 
> Clear, crisp, and 80-wide. I also like how the logical operator on the 
> following line is indented slightly into the condition of the previous 
> line.

The brain works better when associated things are lined up, so:

	if (veryverylengthycondition1 &&
	    smallcond2 &&
	    (conditionnumber3a ||
	     condition3b)) {

is better as it gives a visual clue to association.

David
