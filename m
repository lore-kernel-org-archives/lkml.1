Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXEOFJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXEOFJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXEOFJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:09:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756330AbXEOFJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:09:12 -0400
Date: Mon, 14 May 2007 22:09:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       dang@gentoo.org
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in
 tv_usec on core2duo
Message-Id: <20070514220901.90aab9e0.akpm@linux-foundation.org>
In-Reply-To: <200705150417.l4F4HlvS013354@fire-2.osdl.org>
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 21:17:47 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8479
> 
>            Summary: gettimeofday returning 1000000 in tv_usec on core2duo
>     Kernel Version: 2.6.21
>             Status: NEW
>           Severity: normal
>              Owner: ak@suse.de
>          Submitter: dang@gentoo.org
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.20
> Distribution: Gentoo
> Hardware Environment: core2duo T7200 (all reporters had this same CPU)
> Software Environment: Linux 2.6.21, glibc 2.5
> Problem Description:
> 
> gettimeofday returns 1 - 1000000 in tv_usec, not 0 - 999999 
> This does not happen on any of my AMD-based 32 or 64 bit boxes, only on my
> core2duo; I have 2 other reports of this problem, all on T7200's
> 
> Steps to reproduce:
> 
> call gettimeofday a lot.  Eventually, you'll get 1000000 returned in tv_usec. My
> average is ~1 in 1000000 calls.  I've attached my test program, with output from
> various boxes.  One of the other reporters tried the test program too, and got
> similar output.  .config will be attached too.

err, whoops.
