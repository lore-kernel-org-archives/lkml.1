Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYBXMTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYBXMTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 07:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYBXMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 07:19:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59305 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYBXMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 07:19:38 -0500
Date: Sun, 24 Feb 2008 13:20:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86,fpu: lazy allocation of FPU area
Message-ID: <20080224122005.GA13637@one.firstfloor.org>
References: <20080224023547.264625000@linux-os.sc.intel.com> <20080224023547.412501000@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224023547.412501000@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 06:34:39PM -0800, Suresh Siddha wrote:
> Only allocate the FPU area when the application actually uses FPU, i.e., in the
> first lazy FPU trap. This could save memory for non-fpu using apps.

Did you measure this making any difference? 

At least at some point glibc always touched the FPU once to initialize
it.

-andi
