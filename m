Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYC3Ln4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYC3Ln4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYC3Lnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:43:46 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49964 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYC3Lnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:43:45 -0400
Date: Sun, 30 Mar 2008 15:43:35 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/35] W1: Documentation/w1/masters/ds2490 update
Message-ID: <20080330114335.GM15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122758.GI3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122758.GI3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 07:27:59AM -0500, David Fries (david@fries.net) wrote:
> Provide some additional details about the status of the driver.
> 
> Signed-off-by: David Fries <david@fries.net>
> ---
>  Documentation/w1/masters/ds2490 |   60 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/w1/masters/ds2490 b/Documentation/w1/masters/ds2490
> index 239f9ae..4b7b8ee 100644
> --- a/Documentation/w1/masters/ds2490
> +++ b/Documentation/w1/masters/ds2490
> @@ -16,3 +16,63 @@ which allows to build USB <-> W1 bridges.
>  DS9490(R) is a USB <-> W1 bus master device
>  which has 0x81 family ID integrated chip and DS2490
>  low-level operational chip.
> +
> +Notes and limitations.
> +- The 5V strong pullup is supported.
> +- While the ds2490 supports a hardware search the code doesn't take
> +  advantage of it.

It does not actually - at least my hardware can only find first device
on the bus, so I dropped the implementation.

I generally ack whe whole ds2490 changes except pullup one - it has
to be turned off by default, presumably tested with multiple devices on
the same wire.

David, thanks a lot for your work on w1 drivers.

-- 
	Evgeniy Polyakov
