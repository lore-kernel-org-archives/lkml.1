Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYEVOwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYEVOwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYEVOwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:52:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYEVOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:52:39 -0400
Date: Thu, 22 May 2008 07:51:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080522075135.4933161c@infradead.org>
In-Reply-To: <20080522144114.GC27301@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	<20080522144114.GC27301@cs181133002.pp.htv.fi>
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

On Thu, 22 May 2008 17:41:14 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, May 22, 2008 at 02:28:17PM +0200, Bosko Radivojevic wrote:
> 
> > Hi!
> 
> Hi Bosko!
> 
> > Is there any kind of analysis of number of (reported or resolved)
> > bugs through time in Linux kernel floating around? I'm trying to
> > convince my colleagues that newer kernel version does not mean more
> > bugs than the previous 'well tested' ones.
> 
> We definitely have many regressions (something that previously worked
> does no longer work) in each kernel.

... and many of those regressions are things people are unlikely to
hit. And we fix many long standing bugs as well.

Maybe some other data:
* The incoming rate of ACPI bugs has been pretty much flat the last 3
years, while the number of Linux (and ACPI) users has grown
significantly. The number of unfixed bugs has more than halved, from
over 200 to well below 100.
* The SCSI maintainer also reports that he sees flat to declining bug
rates; again with the increase in Linux user base that is a good sign


> 
> > Any kind of (research) reports or papers that address this issue is
> > more than welcome.
> 
> Any such reports or papers would anyway be flawed since we have no
> data one could use for doing serious statistics.

We have data for 2.6.25 at least, on which we can and do serious
statistics. Unfortunately we don't have that for older kernels.
What we have for older kernels only comes from lkml reports (which
isn't very representative), but that shows that the bug report pattern
is a bit spikey, in that kernels that get picked up by popular
distributions get more reports than those that don't (no big surprise,
those just have a much larger user base), but otherwise there's no up
or down trend to be seen there.


> 
> > Thanks!
> > 
> > Sincerely,
> > Bosko
> 
> cu
> Adrian
> 
