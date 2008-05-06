Return-Path: <linux-kernel-owner+w=401wt.eu-S933870AbYEFXiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbYEFXiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765466AbYEFXi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:38:28 -0400
Received: from mga06.intel.com ([134.134.136.21]:27692 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765805AbYEFXi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:38:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="380728237"
Message-ID: <4820EBEA.7070206@linux.intel.com>
Date: Tue, 06 May 2008 16:38:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <20080501043313.02205bbd@linux.intel.com>	<481CF3B1.2020307@gmail.com>	<4820B64D.4000805@linux.intel.com> <20080506.133416.241365936.davem@davemloft.net> <4820E529.2030801@gmail.com> <4820EA7B.4050406@linux.intel.com> <4820EB5C.2010102@gmail.com>
In-Reply-To: <4820EB5C.2010102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> -march=k8 -mno-red-zone -mcmodel=kernel -funit-at-a-time 
> -maccumulate-outgoing-args -fstack-protector -DGCC_HAS_SP 
> -fstack-protector-all   -pipe -Wno-sign-compare 
   ^^^^^^^^^^^^^^^^^^^^^^
> -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
> -Iinclude/asm-x86/mach-default -fno-omit-frame-pointer 
> -fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement 
> -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" 


the kernel makefiles are doing exactly the right things....
yet your previous data showed that something adds a -fstack-protector
after it.... grrr.

Sounds like I need to figure how to make a testcase for this that we
can then use to, at build time, detect this b0rked gcc behavior.

thanks a lot for helping me diagnosing this so far!

