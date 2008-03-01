Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbYCAMke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbYCAMke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYCAMk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:40:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYCAMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:40:26 -0500
Date: Sat, 1 Mar 2008 13:41:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v2
Message-ID: <20080301124124.GA28230@one.firstfloor.org>
References: <20080301005141.997705000@linux-os.sc.intel.com> <20080301005142.156610000@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301005142.156610000@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 04:51:19PM -0800, Suresh Siddha wrote:
> Only allocate the FPU area when the application actually uses FPU, i.e., in the
> first lazy FPU trap. This could save memory for non-fpu using apps.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>

I reviewed both patches and they look good to me.

Acked-by: Andi Kleen <ak@suse.de>

-Andi
