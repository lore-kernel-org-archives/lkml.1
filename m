Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZJZVeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZJZVeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZJZVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:34:23 -0400
Received: from 17.mail-out.ovh.net ([91.121.30.212]:33896 "HELO
	17.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752839AbZJZVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:34:23 -0400
Date: Mon, 26 Oct 2009 22:14:52 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.32] drivers/serial/atmel_serial.c: Fix BUILD_BUG_ON
 build
Message-ID: <20091026211452.GB2561@game.jcrosoft.org>
References: <1256569964-14416-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256569964-14416-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1704893934510582575
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 1579356095695727383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:12 Mon 26 Oct     , Mark Brown wrote:
> Since 'BUILD_BUG_ON(): fix it and a couple of bogus uses of it'
> (commit 8c87df45) the BUILD_BUG_ON() for the ring buffer size has
> failed to build due to use of is_power_of_2(). Fix this in the
> same way as the SPARC vio.h was fixed in that commit by converting
> to MAYBE_BUILD_BUG_ON().
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
a similatr patch done by Haavard
atmel_serial-fix-bad-build_bug_on-usage.patch 
is already in the -mm

btw when it will be merged?

Best Regards,
J.
