Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXIMGxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXIMGxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXIMGxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:53:45 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:60570 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbXIMGxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:53:45 -0400
Message-ID: <46E8DE8B.8070405@l4x.org>
Date: Thu, 13 Sep 2007 08:54:03 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin arch bug fixing for 2.6.23-rc6
References: <1189662509.24063.2.camel@roc-laptop>
In-Reply-To: <1189662509.24063.2.camel@roc-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> Hi Linus,
> 
> Please pull from 'for-linus' branch of
> 
> master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus
> 
> to receive the following updates:
> 
>  arch/blackfin/mach-common/pm.c              |    6 ++
>  include/asm-blackfin/mach-bf561/cdefBF561.h |    4 +-
>  include/asm-blackfin/string.h               |  129 +++++++++++++++++----------

btw. what about this error?

fs/binfmt_flat.c:760:50: error: macro "flat_get_addr_from_rp" requires 4 
arguments, but only 3 given
fs/binfmt_flat.c:760: error: ‘flat_get_addr_from_rp’ undeclared (first use in 
this function)
fs/binfmt_flat.c:760: error: (Each undeclared identifier is reported only once
fs/binfmt_flat.c:760: error: for each function it appears in.)
make[2]: *** [fs/binfmt_flat.o] Error 1
make[1]: *** [fs] Error 2
make: *** [_all] Error 2

any chance to get that fixed prior to .23? (not a regression, but
happens approx. since blackfin was merged)

Thanks,

Jan

Full build log: http://l4x.org/k/?d=34032
