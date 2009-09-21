Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZIULUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZIULUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZIULUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:20:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbZIULUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:20:47 -0400
Date: Mon, 21 Sep 2009 13:20:59 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Johannes Buchner <buchner.johannes@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Influence of optimization level, preemption and scheduler on
 boot time
Message-ID: <20090921132059.10b2723d@infradead.org>
In-Reply-To: <20090921232553.c97560c7.buchner.johannes@gmx.at>
References: <20090921232553.c97560c7.buchner.johannes@gmx.at>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 23:25:53 +1200
Johannes Buchner <buchner.johannes@gmx.at> wrote:

> Hi all.
> 
> I measured the kernel (and system) boot times while varying the
> parameters:
>  - Optimization level: -Os, -O2 and also -O3
>  - Preemptive model
>  - Scheduler: CFQ, Anticipatory, Deadline, Noop
> 
> My conclusion was that the optimization level and the preemptive model
> had no significant influence on speed. CFQ let my system boot several
> seconds faster than the other schedulers.
> 
> Graphs can be found at:
> http://johannes.jakeapp.com/blog/?p=913
> 
> This conclusion may not be true for all situations, but I found it
> interesting that the optimization level is so irrelevant.
> 

it's interesting to see that the IO scheduler mattered.. 
I would think that (s)readahead makes the IO scheduler irrelevant for
boot time...

--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
