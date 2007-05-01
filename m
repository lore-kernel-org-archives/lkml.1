Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXEAPG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXEAPG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXEAPG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:06:28 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:33501 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXEAPG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:06:27 -0400
Date: Tue, 1 May 2007 11:00:17 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
In-Reply-To: <1178028973.2875.78.camel@pmac.infradead.org>
Message-ID: <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com>
References: <20061127165138.GA2991@lst.de>  <20070430040213.BF9901801A4@magilla.sf.frob.com>
  <20070430091121.GC31397@infradead.org>  <20070430100917.439ebfc8.akpm@linux-foundation.org>
  <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com> 
 <Pine.LNX.4.64.0705011058330.27246@anakin>
 <1178028973.2875.78.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

	if (veryverylengthycondition1
		&& smallcond2
		&& (conditionnumber3a
			|| condition3b)) {
		...
	}

Clear, crisp, and 80-wide. I also like how the logical operator on the 
following line is indented slightly into the condition of the previous 
line. I think this is much more sensical and sensible than using spaces to 
line them up with the parentheses. Makes clear for each operator the 
condition to which it applies.
