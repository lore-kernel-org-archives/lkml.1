Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZIQNjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZIQNjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIQNjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:39:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:44162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZIQNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:39:12 -0400
Date: Thu, 17 Sep 2009 15:39:12 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       yanmin_zhang@linux.intel.com, jens.axboe@oracle.com,
       ink@jurassic.park.msu.ru, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20090917153912.10964432@infradead.org>
In-Reply-To: <20090915162306.66c5ce9d.akpm@linux-foundation.org>
References: <20090915054259.5282e5ba@infradead.org>
	<20090915162306.66c5ce9d.akpm@linux-foundation.org>
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

On Tue, 15 Sep 2009 16:23:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Sep 2009 05:42:59 +0200
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > Fix the menu idle governor which balances power savings, energy
> > efficiency and performance impact.
> 
> This patch clashes a bit with
> cpuidle-menu-governor-reduce-latency-on-exit.patch (which was sent to
> the ACPI maintainers a month ago and ignored).
> 
> <im-fed-up-with-this-crap-ill-just-merge-it-and-if-it-breaks-dont-blame-me>
> 
> 
> I restaged cpuidle-menu-governor-reduce-latency-on-exit.patch so it
> goes after
> cpuidle-fix-the-menu-governor-to-boost-io-performance.patch. perhaps
> you could take a look at Corrado's change?
> 
>  
> 
> From: Corrado Zoccolo <czoccolo@gmail.com>
> 
> Move the state residency accounting and statistics computation off
> the hot exit path.
> 
> On exit, the need to recompute statistics is recorded, and new
> statistics will be computed when menu_select is called again.
> 
> The expected effect is to reduce processor wakeup latency from sleep
> (C-states).  We are speaking of few hundreds of cycles reduction out
> of a several microseconds latency (determined by the hardware
> transition), so it is difficult to measure.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Adam Belay <abelay@novell.com
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I checked the last residency thing... and it's fine

Acked-by: Arjan van de Ven <arjan@linux.intel.com>



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
