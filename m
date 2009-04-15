Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbZDOMXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbZDOMXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZDOMXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:23:06 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:21518
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbZDOMXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:23:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIRu5Ul8qNw9/2dsb2JhbADSX4N+Bg
X-IronPort-AV: E=Sophos;i="4.40,192,1238947200"; 
   d="scan'208";a="482651723"
Message-ID: <49E5D1A2.7010901@eyal.emu.id.au>
Date: Wed, 15 Apr 2009 22:22:58 +1000
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Organization: Eyal at Home
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc2
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get a build failure with this one:

   LD      vmlinux.o
   MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
arch/x86/mm/built-in.o(.init.text+0x178a): In function `memtest':
: undefined reference to `__udivdi3'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

I have
	gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)

I know, very old Debian... but the doco says required version is 3.2.

A quick search indicates that this type of failure may be related to
gcc version related optimization. I saw similar reports in linux-next recently.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
