Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYJYOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYJYOpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYJYOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:45:10 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:37056 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbYJYOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:45:09 -0400
Date: Sat, 25 Oct 2008 15:45:02 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] sgi_btns: add license specification
Message-ID: <20081025144502.GA2050@linux-mips.org>
References: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi> <1224888417-26494-2-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224888417-26494-2-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 01:46:57AM +0300, Dmitri Vorobiev wrote:

> The SGI Volume Button interface driver uses GPL-only symbols
> platform_driver_unregister and platform_driver_register, but
> lacks license specification. Thus, when compiled as a module,
> this driver cannot be installed. This patch fixes this by
> adding the MODULE_LICENSE() specification.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

Patch is correct - but it stumped my nose at another bug.

A platform driver is supposed to be safe if loaded into a kernel for another
machine.  With the #ifdef'ed sections of this driver, a crash would be
likely if the module built for IP22 would be loaded into an IP32 kernel or
vice versa.

  Ralf
