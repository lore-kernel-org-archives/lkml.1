Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYHHQnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYHHQnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbYHHQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:43:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760023AbYHHQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:43:03 -0400
Date: Fri, 8 Aug 2008 09:41:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <1218202249.8625.106.camel@twins>
Message-ID: <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>  <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>  <1206382547.6437.131.camel@lappy>  <20080324115738.85c72bb5.akpm@linux-foundation.org> <1218202249.8625.106.camel@twins>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:
> 
> Something along the lines of the below patch?

Could we not literally just make this a RCU event? Unconditionally too?

			Linus
