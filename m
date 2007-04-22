Return-Path: <linux-kernel-owner+w=401wt.eu-S1030837AbXDVNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837AbXDVNJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030847AbXDVNJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:09:49 -0400
Received: from 1wt.eu ([62.212.114.60]:2191 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030837AbXDVNJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:09:48 -0400
Date: Sun, 22 Apr 2007 15:07:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Message-ID: <20070422130725.GA16601@1wt.eu>
References: <200704221441.48897.kernel@kolivas.org> <20070422091451.GA15913@1wt.eu> <200704222142.52325.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222218.32754.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 10:18:32PM +1000, Con Kolivas wrote:
> On Sunday 22 April 2007 21:42, Con Kolivas wrote:
> 
> Willy I'm still investigating the idle time and fluctuating load as a separate 
> issue.

OK.

> Is it possible the multiple ocbench processes are naturally 
> synchronising and desynchronising and choosing to sleep and/or run at the 
> same time?

I don't think so. They're independant processes, and I insist on reducing
their X work in order to ensure they don't get perturbated by external
factor. Their work consist in looping 250 ms and waiting 750 ms, then
displaying a new progress line.

> I can remove the idle time entirely by running ocbench at nice 19 
> which means they are all forced to run at basically the same time by the 
> scheduler.

It may indicate some special handling of nice ?

> Anyway the more important part is... Can you test this patch please? Dump
> all the other patches I sent you post 045. Michael, if you could test too
> please?

OK, I will restart from fresh 0.45 and try again.

Regards,
Willy

