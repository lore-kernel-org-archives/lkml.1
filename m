Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYE0E1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYE0E1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYE0E1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:27:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32813 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYE0E1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:27:14 -0400
Date: Mon, 26 May 2008 21:20:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, benh@kernel.crashing.org,
       linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080526212010.664302cf@infradead.org>
In-Reply-To: <adad4n82xud.fsf@cisco.com>
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<adad4n82xud.fsf@cisco.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 21:08:10 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > either via sparse or some fancy lockdep like "device store" thing?
>  > If we can't test for it and it doesn't show up on x86 ... it'll
>  > just be an eterrnal chase.
> 
> Ben's point is that it will start showing up on x86 because newer
> compilers are reordering things...
> 
>  - R.


I know a basic reorder will show up there. A simple "barrier()" in
readl/writel solves it for x86. Understandably, Ben doesn't really like
that answer ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
