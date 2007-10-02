Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXJBH7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXJBH7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXJBH70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:59:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51130 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXJBH7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:59:25 -0400
Date: Tue, 2 Oct 2007 09:59:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002075924.GB30490@one.firstfloor.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org> <20071002070110.GA30490@one.firstfloor.org> <20071002001809.0a814d0b.akpm@linux-foundation.org> <20071002075549.GH19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002075549.GH19691@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Grumble. The options are:
> 
> a) export it in the kernel's native size and have userspace figure it
> out
> b) add a header
> c) lie to 32-bit apps on 64-bit kernels
> d) always export 32 bits
> e) always export 64 bits
> 
> I started with (a), switched to (b), and then Alan and Dave convinced
> me to switch back to (a). I don't think (c) is desireable, especially
> as it means having two code paths. (d) would work until memory got
> large enough that PFNs didn't fit in 32 bits. (e) would be ok all
> around, except for the extra overhead. Ho hum.

If the overhead of (e) is ok for 64bit it should be ok for 32bit too.

-Andi
