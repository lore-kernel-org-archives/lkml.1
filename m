Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbYCFT1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbYCFT1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYCFT1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:27:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:48235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760270AbYCFT1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:27:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,457,1199692800"; 
   d="scan'208";a="215644672"
Date: Thu, 6 Mar 2008 11:26:53 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080306192653.GI28006@linux-os.sc.intel.com>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080305194801.GB4386@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305194801.GB4386@ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:48:01PM +0100, Pavel Machek wrote:
> On Mon 2008-03-03 15:02:46, Suresh Siddha wrote:
> > Only allocate the FPU area when the application actually uses FPU, i.e., in the
> > first lazy FPU trap. This could save memory for non-fpu using apps.
> 
> How many such apps are on your system, and how much does this
> 'optimalization' cost?

On a normal kernel boot, where there are 200 or so tasks running, only 20
or so apps seem to be using FPU.

> ISTR glibc always using FPU...?

Apparently not, alteast not on my system. And also going forward, as we extend
this state, thought is nice to have.

thanks,
suresh
