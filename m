Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYH0RXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYH0RXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYH0RXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:23:23 -0400
Received: from flusers.ccur.com ([12.192.68.2]:60936 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750990AbYH0RXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:23:22 -0400
Date: Wed, 27 Aug 2008 13:22:58 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Mark Brown <broonie@sirena.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression, v2
Message-ID: <20080827172258.GA24454@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827151613.GA10325@tsunami.ccur.com> <20080827161621.GF10834@sirena.org.uk> <20080827170424.GA17217@tsunami.ccur.com> <48B58B38.30303@onelan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B58B38.30303@onelan.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:13:28PM -0400, Simon Farnsworth wrote:
> Joe Korty wrote:
> > On Wed, Aug 27, 2008 at 12:16:30PM -0400, Mark Brown wrote:
> >> It'd be nicer if this were optional - syslog typically only logs at
> >> second resolution and not all systems are going to have logfiles.
> >
> >
> > Optionally suppress printk timestamping after system boot.
> >
> JOOI, what's wrong with having your init scripts contain a line like:
> echo 0 > /sys/module/printk/parameters/time
> ?
> 
> This has the advantage that you can avoid turning the kernel's
> timestamps off until you know that syslog is running and timestamp
> events that it's receiving.
> --
> Simon Farnsworth


That certainly is the better approach.
Joe
