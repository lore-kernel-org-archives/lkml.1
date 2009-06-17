Return-Path: <linux-kernel-owner+w=401wt.eu-S1765923AbZFQMUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765923AbZFQMUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbZFQMUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:20:22 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44391 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbZFQMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:20:21 -0400
Date: Wed, 17 Jun 2009 14:20:22 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       Borislav Petkov <petkovbb@googlemail.com>, akpm@linux-foundation.org,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-ID: <20090617122022.GA13141@rhlx01.hs-esslingen.de>
References: <20090604211103.4214303f.peter@piie.net> <cone.1245086149.988051.6046.1000@deskpiie> <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca> <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617001435.e2d86780.peter@piie.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 17, 2009 at 12:14:35AM +0200, Peter Feuerer wrote:
> Hi,
> 
> Andreas, I applied and reviewd your patch and additionally changed following things:
> o added "acerhdf_enable_kernelmode" which is the opposite of your "acerhdf_revert_to_bios_mode".

Good idea.

> o suspend stops and resume starts the kernelmode in a clean way

Didn't someone argue that pre_suspend_kernelmode was unnecessary?
It's still in there. (could be submitted together with the
Kconfig ACPI depends ;)

> I tested the patch with current linus git. Unfortunately does the current state of the kernel freeze my a1 after suspend/resume randomly (also without acerhdf). Anyways I was able to do 11 suspend / resume cycles with acerhdf loaded and kernelmode=on.

Oh no, not again.

Thanks!

Andreas Mohr
