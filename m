Return-Path: <linux-kernel-owner+w=401wt.eu-S940667AbYCTAis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940667AbYCTAis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966421AbYCTAYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:24:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38976 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbYCTAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:24:16 -0400
Date: Wed, 19 Mar 2008 17:23:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Luciano Rocha <luciano@eurotux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: target headers_install: no linux/if_addrlabel.h (2.6.24.3)
Message-Id: <20080319172310.08071b27.randy.dunlap@oracle.com>
In-Reply-To: <20080318152437.GA29674@bit.office.eurotux.com>
References: <20080318152437.GA29674@bit.office.eurotux.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 15:24:37 +0000 Luciano Rocha wrote:

> 
> Hello,
> 
> I've compiled Linux 2.6.24.3 for arm, using gcc 4.3.0, and I get the
> following error when trying to extract the kernel headers. Is this
> known, or do I have a problem with my configuration?
> 
> $ nice make -C /home/luciano/work/gilix/v2/src/linux O=$PWD ARCH=arm \
>   CROSS_COMPILE=arm-unknown-linux-gnueabi- V=1 \
>   modules_install INSTALL_MOD_PATH=$PWD/dist \
>   headers_install INSTALL_HDR_PATH=$PWD/dist/usr
> 
> ...
>   scripts/unifdef -U__KERNEL__ /home/luciano/work/gilix/v2/src/linux/include/linux/icmpv6.h | sed 	-e "s/ inline / __inline__ /g" -e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" -e "s/(__user[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" -e "s/(__force[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" -e "s/(__iomem[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" -e "s/[[:space:]]__attribute_const__$//" -e "/^#include <linux\/compiler.h>/d" > /home/luciano/work/gilix/v2/build/linux/dist/usr/include/linux/icmpv6.h || :
>   scripts/unifdef -U__KERNEL__ /home/luciano/work/gilix/v2/src/linux/include/linux/if_addr.h | sed 	-e "s/ inline / __inline__ /g" -e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" -e "s/(__user[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" -e "s/(__force[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" -e "s/(__iomem[[:space:]]\{1,\}/ (/g" -e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" -e "s/[[:space:]]__attribute_const__$//" -e "/^#include <linux\/compiler.h>/d" > /home/luciano/work/gilix/v2/build/linux/dist/usr/include/linux/if_addr.h || :
> make[3]: *** No rule to make target `/home/luciano/work/gilix/v2/src/linux/include/linux/if_addrlabel.h', needed by `/home/luciano/work/gilix/v2/build/linux/dist/usr/include/linux/if_addrlabel.h'.  Stop.
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_install] Error 2
> make: *** [sub-make] Error 2

The fix for this is queued and will be present (fixed) in the
next 2.6.24.x stable release.

---
~Randy
