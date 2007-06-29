Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXF2MxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXF2MxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXF2Mwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:52:54 -0400
Received: from h155.mvista.com ([63.81.120.155]:12579 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752825AbXF2Mwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:52:54 -0400
Message-ID: <4685010C.4000108@ru.mvista.com>
Date: Fri, 29 Jun 2007 16:54:36 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: kgdb-bugreport@lists.sourceforge.net
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <200706291432.10128.m.kozlowski@tuxland.pl>
In-Reply-To: <200706291432.10128.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mariusz Kozlowski wrote:

> 	allmodconfig on powerpc (iMac g3) fails due to
> git-kgdb.patch. allmodconfig defaults should be changed?

>   CC      arch/powerpc/kernel/kgdb.o
> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB selected 
> in .config. Unselect one of them.
> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

    I'm not sure if this will work out but maybe it's worth to disable XMON if 
KGDB is selected, like this?

config XMON
	bool "Include xmon kernel debugger"
	depends on DEBUGGER && !KGDB

> Regards,

> 	Mariusz

WBR, Sergei
