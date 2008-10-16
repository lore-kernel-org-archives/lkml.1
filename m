Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYJPME2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYJPME2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYJPMET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:04:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34635 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754203AbYJPMES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:04:18 -0400
Date: Thu, 16 Oct 2008 13:04:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd/wm8350: don't export static functions
Message-ID: <20081016120416.GA5753@rakim.wolfsonmicro.main>
References: <20081016204754.a41646e5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016204754.a41646e5.sfr@canb.auug.org.au>
X-Cookie: I program, therefore I am.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:47:54PM +1100, Stephen Rothwell wrote:
> Today's linux-next build (powerpc allyesconfig) failed like this:

> drivers/mfd/wm8350-core.c:1131: error: __ksymtab_wm8350_create_cache causes a section type conflict

> Caused by commit 89b4012befb1abca5e86d232bc0e2a797b0d9825 ("mfd: Core
> support for the WM8350 AudioPlus PMIC"). wm8350_create_cache is not used
> elsewhere, so remove the EXPORT_SYMBOL.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
