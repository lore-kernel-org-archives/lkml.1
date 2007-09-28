Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXI1CQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXI1CQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbXI1CQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:16:08 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:38093 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754651AbXI1CQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:16:07 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 22:16:07 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] i915: make vbl interrupts work properly on i965g/gm
Date: Thu, 27 Sep 2007 19:09:22 -0700
User-Agent: KMail/1.9.7
Cc: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271909.23040.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 27, 2007 7:05:31 pm Dave Airlie wrote:
> Hi Linus,
>
> The attached patch is to fix a bug reported on 965gm chipsets (lots of new
> laptops), I think distros will all have to patch this in to fix it, so can
> we get it into the 2.6.23 final?
>
> (Otherwise I'll wait until stable..)

Without this patch, my 965GM drops vblank interrupts, so I'd really like to 
see it upstream ASAP too.

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
