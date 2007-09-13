Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXIMHCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXIMHCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXIMHCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:02:44 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:20771 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXIMHCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:02:43 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="39525276:sNHT27991173"
Subject: Re: [GIT PULL] Blackfin arch bug fixing for 2.6.23-rc6
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jan Dittmer <jdi@l4x.org>
Cc: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <46E8DE8B.8070405@l4x.org>
References: <1189662509.24063.2.camel@roc-laptop> <46E8DE8B.8070405@l4x.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Analog Devices, Inc.
Date: Thu, 13 Sep 2007 14:58:58 +0800
Message-Id: <1189666738.30686.6.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 07:02:42.0103 (UTC) FILETIME=[14040C70:01C7F5D4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 08:54 +0200, Jan Dittmer wrote:
> Bryan Wu wrote:
> > Hi Linus,
> > 
> > Please pull from 'for-linus' branch of
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus
> > 
> > to receive the following updates:
> > 
> >  arch/blackfin/mach-common/pm.c              |    6 ++
> >  include/asm-blackfin/mach-bf561/cdefBF561.h |    4 +-
> >  include/asm-blackfin/string.h               |  129 +++++++++++++++++----------
> 
> btw. what about this error?
> 
> fs/binfmt_flat.c:760:50: error: macro "flat_get_addr_from_rp" requires 4 
> arguments, but only 3 given
> fs/binfmt_flat.c:760: error: ‘flat_get_addr_from_rp’ undeclared (first use in 
> this function)
> fs/binfmt_flat.c:760: error: (Each undeclared identifier is reported only once
> fs/binfmt_flat.c:760: error: for each function it appears in.)
> make[2]: *** [fs/binfmt_flat.o] Error 1
> make[1]: *** [fs] Error 2
> make: *** [_all] Error 2
> 

Thanks for the testing.

> any chance to get that fixed prior to .23? (not a regression, but
> happens approx. since blackfin was merged)
> 

This is because a binfmt_flat hacking patch for Blackfin arch is not
accept by the mainline. It can be workaround by disabling
CONFIG_BINFMT_FLAT in menuconfig.

Need I disable CONFIG_BINFMT_FLAT in defconfigs for Blackfin to make the
compile pass?

> Full build log: http://l4x.org/k/?d=34032

Thanks again, beautiful log and which defconfigs do you using to do the
test and what's the toolchain version?

Best Regards
-Bryan Wu
