Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYBXQgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYBXQgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbYBXQfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:35:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:4338 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523AbYBXQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:35:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,398,1199692800"; 
   d="scan'208";a="382933237"
Date: Sun, 24 Feb 2008 08:32:29 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86,fpu: lazy allocation of FPU area
Message-ID: <20080224163228.GD27194@linux-os.sc.intel.com>
References: <20080224023547.264625000@linux-os.sc.intel.com> <20080224023547.412501000@linux-os.sc.intel.com> <20080224122005.GA13637@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224122005.GA13637@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 01:20:05PM +0100, Andi Kleen wrote:
> On Sat, Feb 23, 2008 at 06:34:39PM -0800, Suresh Siddha wrote:
> > Only allocate the FPU area when the application actually uses FPU, i.e., in the
> > first lazy FPU trap. This could save memory for non-fpu using apps.
> 
> Did you measure this making any difference? 
> 
> At least at some point glibc always touched the FPU once to initialize
> it.

Simple kernel boot showed that only 20 or so tasks using FPU, out of 
200 or so tasks running.

thanks,
suresh
