Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbXG1Qkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbXG1Qkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXG1Qkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:40:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:28427 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbXG1Qkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kGA9u1o6m91gl08PgGADYApFtV/ssLxPKwFtVN0dFuv4DT7SbMrMpSoW4nGFqeHB5ZBCQdW2F+claWwr5ylTjzN4ADtlxAUPywQk1zZrg/rzubEM2liq97Kl7vzkEldapYCjRZy6VxB3i8MMcnC6y+d63E3OsqBlvlRvOgS/5JI=
Message-ID: <46AB7091.3030508@googlemail.com>
Date: Sat, 28 Jul 2007 18:36:33 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: DCA=n , INTEL_IOATDMA=y compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this error with a randconfig ( http://194.231.229.228/MM/randconfig-auto-86.ioat )

...

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ioat_shutdown_functionality':
ioat.c:(.text+0x21ed32): undefined reference to `unregister_dca_provider'
ioat.c:(.text+0x21ed3a): undefined reference to `free_dca_provider'
drivers/built-in.o: In function `ioat_dca_init':
(.text+0x2201f3): undefined reference to `alloc_dca_provider'
drivers/built-in.o: In function `ioat_dca_init':
(.text+0x22022e): undefined reference to `register_dca_provider'
drivers/built-in.o: In function `ioat_dca_init':
(.text+0x22023b): undefined reference to `free_dca_provider'
make: *** [.tmp_vmlinux1] Error 1

...


Regards,

Gabriel C
