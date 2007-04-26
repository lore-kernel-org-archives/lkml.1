Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXDZUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXDZUwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXDZUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:52:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53857 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbXDZUww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:52:52 -0400
Subject: Re: [PATCH 2/3] ia64: remove interpolater code
From: john stultz <johnstul@us.ibm.com>
To: Peter Keilty <peter.keilty@hp.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Whitney <eric.whitney@hp.com>, davem@davemloft.net
In-Reply-To: <20070426202702.23343.10036.sendpatchset@rambler.zko.hp.com>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
	 <20070426202702.23343.10036.sendpatchset@rambler.zko.hp.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 13:52:47 -0700
Message-Id: <1177620767.6031.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 16:27 -0400, Peter Keilty wrote:
> From: Peter Keilty <peter.keilty@hp.com>
> 
> Remove time_interpolator code.
> 
> Signed-off-by: Peter Keilty <peter.keilty@hp.com>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> ---
> 
>  include/linux/timex.h |   60 ---------------
>  kernel/time.c         |    1 
>  kernel/timer.c        |  193 --------------------------------------------------
>  3 files changed, 254 deletions(-)

This specific patch may need to be held off until Dave Miller pushes his
SPARC64 GENERIC_TIME conversion (as SPARC64 currently uses the
time_interpolator code). 

I think Dave intends to push it soon, so it shouldn't be a long wait.

thanks
-john


