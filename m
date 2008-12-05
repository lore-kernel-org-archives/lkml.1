Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYLEO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYLEO7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYLEO7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:59:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:52273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYLEO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:59:37 -0500
Date: Fri, 5 Dec 2008 07:00:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       hpa@zytor.com, rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205070042.0b8a3ef5@infradead.org>
In-Reply-To: <20081205.000716.40104924.davem@davemloft.net>
References: <1228461385.18899.13.camel@twins>
	<18744.57057.243817.407691@cargo.ozlabs.ibm.com>
	<1228464216.18899.18.camel@twins>
	<20081205.000716.40104924.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 00:07:16 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> These things aren't measuring time, or even just cycles, they
> are measuring things like L2 cache misses, cpu cycles, and
> other similar kinds of events.
> 
> So these counters are going to measure all of the damn crap
> assosciated with doing the read() call as well as the real work
> the task does.

as you said before, not if you do the read() from a thread that's
exempt from the profiling.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
