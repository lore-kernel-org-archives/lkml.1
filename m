Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbZD3Xs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbZD3Xs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbZD3Xrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:47:41 -0400
Received: from ru.mvista.com ([213.79.90.228]:5175 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754599AbZD3Xrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:47:40 -0400
Date: Fri, 1 May 2009 03:47:39 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Some work for spi_mpc83xx driver, spi-mmc support for
	MPC8610HPCD
Message-ID: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are few patches that are needed to support spi-mmc slot on
MPC8610HPCD PowerPC boards:

[1/9] spi_mpc83xx: Handles other Freescale processors
[2/9] spi_mpc83xx: Quieten down the "Requested speed is too low" message
[3/9] spi_mpc83xx: Add small delay after asserting chip-select line
[4/9] powerpc/86xx: Add MMC SPI support for MPC8610HPCD boards

The rest are cleanups, initially Kumar suggested to rename
spi_mpc83xx.c to spi_mpc8xxx.c, but checkpatch told me to fix
some other issues. So the following cleanups were prepared:

[5/9] spi_mpc83xx: Fix checkpatch issues
[6/9] spi_mpc83xx: Split mpc83xx_spi_work() into two routines
[7/9] spi_mpc83xx: Remove dead code
[8/9] spi_mpc83xx: Rename spi_83xx.c to spi_8xxx.c
[9/9] spi_mpc8xxx: s/83xx/8xxx/g

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
