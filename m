Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXGYSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXGYSA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761800AbXGYSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:00:10 -0400
Received: from main.gmane.org ([80.91.229.2]:60357 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbXGYSAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:00:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: Re: -mm merge plans for 2.6.23
Date: Wed, 25 Jul 2007 18:55:43 +0100
Message-ID: <f882qv$grl$1@sea.gmane.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>		<200707102015.44004.kernel@kolivas.org>		<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>		<46A57068.3070701@yahoo.com.au>		<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>		<46A58B49.3050508@yahoo.com.au>		<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>		<46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>	<1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 88-97-16-53.dsl.zen.co.uk
User-Agent: Icedove 1.5.0.12 (X11/20070607)
In-Reply-To: <46A6E1A1.4010508@yahoo.com.au>
Cc: ck@vds.kolivas.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> OK, this is where I start to worry. Swap prefetch AFAIKS doesn't fix
> the updatedb problem very well, because if updatedb has caused swapout
> then it has filled memory, and swap prefetch doesn't run unless there
> is free memory (not to mention that updatedb would have paged out other
> files as well).

It is *not* about updatedb. That is just a trivial case which people 
notice. Therefore fixing updatedb to be nicer, as was discussed at 
various points in this thread, is *not* the solution.
Most users are also *not*at*all* interested in kernel builds as a metric 
of system performance.

When I'm at work, I run a large, commercial, engineering application. 
While running, it takes most of the system memory (4GB and up), and it 
reads and writes very large files. Swap prefetch noticeably helps my 
desktop too. Can I measure it? Not sure. Can people on lkml fix the 
application? Certainly not.

Frank

