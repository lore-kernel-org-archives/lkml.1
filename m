Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbXHHCcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbXHHCcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbXHHCcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:32:33 -0400
Received: from 207.47.19.6.static.nextweb.net ([207.47.19.6]:15177 "EHLO
	ex1.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495AbXHHCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:32:32 -0400
Date: Wed, 8 Aug 2007 10:27:05 +0800
From: Jerry Jiang <wjiang@resilience.com>
To: Chris Snook <csnook@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
Message-Id: <20070808102705.9d91a14c.wjiang@resilience.com>
In-Reply-To: <46B8D6D7.2020206@redhat.com>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
	<20070806123551.a6c3c154.wjiang@resilience.com>
	<46B72C58.5030502@redhat.com>
	<46B894E4.4010501@nortel.com>
	<46B8D6D7.2020206@redhat.com>
Organization: Resilience
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2007 02:32:21.0921 (UTC) FILETIME=[5929B110:01C7D964]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 16:32:23 -0400
Chris Snook <csnook@redhat.com> wrote:

> > It seems like this would fall more into the case of the arch providing 
> > guarantees when using locked/atomic access rather than anything 
> > SMP-related, no?.
> 
> But if you're not using SMP, the only way you get a race condition is if your 
> compiler is reordering instructions that have side effects which are invisible 
> to the compiler.  This can happen with MMIO registers, but it's not an issue 
> with an atomic_t we're declaring in real memory.
> 

Under non-SMP, some compilers would reordering instructions as they think
and C standard informally guarantees all operations on volatile data
are executed in the sequence in which they appear in the source code,
right?

So no reordering happens with volatile, right?

-- Jerry

> 	-- Chris
