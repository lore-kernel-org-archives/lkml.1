Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbXLGSAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbXLGSAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXLGSAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:00:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbXLGSAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:00:41 -0500
Date: Fri, 7 Dec 2007 09:59:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <1197049846.1645.68.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
References: <1197049846.1645.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Dec 2007, Steven Rostedt wrote:
> 
> The regression is that hackbench slows down tremendously. It goes from
> running just under 2 seconds to running around 14 seconds.

Can you do one run with oprofile, and see exactly where the cost is? It 
should hopefully be pretty darn obvious, considering your timing.

			Linus
