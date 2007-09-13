Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbXIMIMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbXIMIMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXIMIMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:12:42 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:35246 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbXIMIMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:12:41 -0400
Message-ID: <46E8F106.9090508@l4x.org>
Date: Thu, 13 Sep 2007 10:12:54 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [GIT PULL] Blackfin arch bug fixing for 2.6.23-rc6
References: <1189662509.24063.2.camel@roc-laptop> <46E8DE8B.8070405@l4x.org> <1189666738.30686.6.camel@roc-desktop>
In-Reply-To: <1189666738.30686.6.camel@roc-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> Need I disable CONFIG_BINFMT_FLAT in defconfigs for Blackfin to make the
> compile pass?

That would be a workaround, yes. Better would be of course to fix
the bug or the Kconfig dependency.

>> Full build log: http://l4x.org/k/?d=34032
> 
> Thanks again, beautiful log and which defconfigs do you using to do the
> test and what's the toolchain version?

All information is on the page:

ld-version 2.17
gcc-version 4.1.2 (adi svn)

make HOSTCC=gcc-4.0 ARCH=blackfin CROSS_COMPILE=bfin-elf- CROSS32_COMPILE= 
O=/tmp/tmp.vLOkGP3410/out/blackfin defconfig

Jan
