Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYH0R2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYH0R2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYH0R2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:28:12 -0400
Received: from flusers.ccur.com ([12.192.68.2]:33160 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750816AbYH0R2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:28:11 -0400
Date: Wed, 27 Aug 2008 13:27:50 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Mark Brown <broonie@sirena.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression, v2
Message-ID: <20080827172750.GA24564@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827151613.GA10325@tsunami.ccur.com> <20080827161621.GF10834@sirena.org.uk> <20080827170424.GA17217@tsunami.ccur.com> <48B58B38.30303@onelan.com> <20080827172258.GA24454@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827172258.GA24454@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:22:58PM -0400, Joe Korty wrote:
> On Wed, Aug 27, 2008 at 01:13:28PM -0400, Simon Farnsworth wrote:
> > Joe Korty wrote:
> > > Optionally suppress printk timestamping after system boot.
> > >
> > JOOI, what's wrong with having your init scripts contain a line like:
> > echo 0 > /sys/module/printk/parameters/time
> > 
> > This has the advantage that you can avoid turning the kernel's
> > timestamps off until you know that syslog is running and timestamp
> > events that it's receiving.
> 
> That certainly is the better approach.

...and is already present in 2.6.27, the module_param_named(...)
stmt in kernel/printk.c sets it all up.

Joe
