Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775Ab0ANKUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0ANKUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580Ab0ANKUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:20:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59988 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751622Ab0ANKUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:20:30 -0500
Date: Thu, 14 Jan 2010 10:20:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 2.6.33] s3c-fb: Fix handling of missing refresh in
 platform data
Message-ID: <20100114102027.GC437@rakim.wolfsonmicro.main>
References: <1263399402-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100114073617.GT3738@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114073617.GT3738@trinity.fluff.org>
X-Cookie: Information is the inverse of entropy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 07:36:17AM +0000, Ben Dooks wrote:

> Thirdly he's changed the code to calculate the divider to assume pixclk
> is a frequency, and not a time-period. It clearly stats in the docs
> that pixclk is in picoseconds. Our clock rate is in Hz.

> It seems I wasn't cc'd on the original submission or I'd have said no.

> I'd rather see this one reverted.

A revert also does the job for SMDK6410 (and does it better) so that
sounds good to me too - I'd been wondering why I couldn't figure out
what was supposed to go in there.  I'll send something out with a
changelog shortly.
