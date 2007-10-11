Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXJKFbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXJKFbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXJKFbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:31:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48918 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXJKFbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:31:05 -0400
Date: Thu, 11 Oct 2007 11:01:12 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       yanmin.zhang@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
Message-ID: <20071011053112.GB5228@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20071010015922.GC30676@linux-os.sc.intel.com> <200710101536.59156.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710101536.59156.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 03:36:58PM +0200, Andi Kleen wrote:
> On Wednesday 10 October 2007 03:59:22 Siddha, Suresh B wrote:
> > Appended patch fixes an oops while changing the vsyscall sysctl.
> > I am sure no one tested this code before integrating into mainline :(
> 
> The original code worked, but got broken by 0dbf7028c0c1f266c9631139450a1502d3cd457e
> > 

Yep. My mistake. I did not test this aspect of the patch. System booted
fine with all the applications running so I assumed things are fine.

Thanks Suresh. This patch looks good.

Thanks
Vivek
