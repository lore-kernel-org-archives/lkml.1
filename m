Return-Path: <linux-kernel-owner+w=401wt.eu-S935420AbXJSJB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420AbXJSJB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbXJSJBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:01:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1737 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763415AbXJSJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:01:19 -0400
Date: Fri, 19 Oct 2007 10:01:15 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
Message-ID: <20071019090115.GE21136@shadowen.org>
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org> <20071018193929.GA22031@elte.hu> <4717BBD0.7070504@qumranet.com> <20071018205147.GA1382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018205147.GA1382@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 10:51:47PM +0200, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@qumranet.com> wrote:
> 
> > >> 	if (foo)
> > >> 		bar();
> > >> 		baz();
> > >> 	one();
> > >>     
> > >
> > > detecting that would be awesome - it's often the sign of a real bug 
> > > because the intent is often to have bar() and baz() in the conditional 
> > > block.
> > 
> > This is more useful operating on an entire file, so the script can see 
> > all the context.
> 
> there's "checkpatch --file" for complete files, so it can see the full 
> context if the user passes it in.

Indeed so.  checkpatch uses all the context it can when making a
decision.  Often 3 lines carries enough history to figure this out.

-apw
