Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZA0P6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZA0P6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZA0P55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:57:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZA0P54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:57:56 -0500
Date: Tue, 27 Jan 2009 10:57:43 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
Message-ID: <20090127155743.GE5034@bombadil.infradead.org>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org> <20090127051919.GA5034@bombadil.infradead.org> <20090126212615.2658b29e.akpm@linux-foundation.org> <20090126212918.d4770115.akpm@linux-foundation.org> <20090127053920.GB5034@bombadil.infradead.org> <alpine.LFD.2.00.0901270741490.3123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901270741490.3123@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:45:41AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 27 Jan 2009, Kyle McMartin wrote:
> > 
> > Suggest using the get_task_comm accessor versus direct access to
> > current->comm.
> 
> I think "current->comm" is fine, and not racy.
> 
> It only gets racy when you ask for the name of _another_ task.
> 
> And quite frankly, I don't think anybody but /proc does that anyway. I 
> think this whole "get_task_comm()" thing is overrated. Most people are 
> better off doing just "current->comm".
> 

Sure, fine by me. I'd forgotten that prctl doesn't have a `pid' argument
to change another tasks comm.

regards, Kyle
