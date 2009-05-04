Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZEDXhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZEDXhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZEDXgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:36:49 -0400
Received: from ru.mvista.com ([213.79.90.228]:12910 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757734AbZEDXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:36:48 -0400
Date: Tue, 5 May 2009 03:36:48 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: galak@kernel.crashing.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Some work for spi_mpc83xx driver, spi-mmc support
	for MPC8610HPCD
Message-ID: <20090504233648.GA6973@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru> <20090504135504.a6a6afcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090504135504.a6a6afcf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 01:55:04PM -0700, Andrew Morton wrote:
> On Fri, 1 May 2009 03:47:39 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > Here are few patches that are needed to support spi-mmc slot on
> > MPC8610HPCD PowerPC boards:
> > 
> > [1/9] spi_mpc83xx: Handles other Freescale processors
> > [2/9] spi_mpc83xx: Quieten down the "Requested speed is too low" message
> > [3/9] spi_mpc83xx: Add small delay after asserting chip-select line
> > [4/9] powerpc/86xx: Add MMC SPI support for MPC8610HPCD boards
> > 
> 
> Some or all of these seem appropriate to 2.6.30 and perhaps even -stable?

I'd say no, we don't need the fixes for MPC8323E-RDB boards
(currently the only mainline user of that driver), and support
for MPC8610HPCD boards is a new feature, so I think all these
patches can wait for 2.6.31.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
