Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbXGUGET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbXGUGET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXGUGEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:04:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259AbXGUGEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:04:02 -0400
Date: Fri, 20 Jul 2007 23:03:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] compacting file_ra_state
Message-Id: <20070720230344.bed611b6.akpm@linux-foundation.org>
In-Reply-To: <20070721055706.GA5097@one.firstfloor.org>
References: <20070721035733.951838089@mail.ustc.edu.cn>
	<20070721035850.977231489@mail.ustc.edu.cn>
	<384990797.09024@ustc.edu.cn>
	<alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
	<20070721055706.GA5097@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 07:57:06 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Jul 20, 2007 at 09:27:01PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Sat, 21 Jul 2007, Fengguang Wu wrote:
> > >
> > > Sorry, forgot to prefix the patch titles with [readahead].
> > > Should I repost?
> > 
> > Not for me, but on the other hand, I'd prefer for this to be in -mm a bit, 
> 
> Haven't the readahead patches already essentially been in -mm* for some time?
> I thought the new patches were some some restructured code, but essentially
> the tested algorithms? 
> 

The all-singing all-dancging readahead code was in -mm for maybe a year. 
Then the much-reduced, feasible-for-merging code was in -mm for several
months.  It went mainline this week.

This new patch series is some optimisation and algorithm tweaking on top of
the recently-merged well-tested stuff.  Waiting for 2.6.24 is appropriate.


