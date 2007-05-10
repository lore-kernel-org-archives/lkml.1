Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbXEJLse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbXEJLse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbXEJLs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:48:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3845 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbXEJLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:48:26 -0400
Message-ID: <4643068C.8010302@shadowen.org>
Date: Thu, 10 May 2007 12:48:28 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: 2.6.21-mm2 -- powerpc missing kset
References: <20070509012322.199f292b.akpm@linux-foundation.org>
In-Reply-To: <20070509012322.199f292b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this new compile failure on powerpc:

-apw

arch/powerpc/platforms/pseries/power.c:31: warning: `struct subsystem'
declared inside parameter list
arch/powerpc/platforms/pseries/power.c:31: warning: its scope is only
this definition or declaration, which is probably not what you want
arch/powerpc/platforms/pseries/power.c:37: warning: `struct subsystem'
declared inside parameter list
arch/powerpc/platforms/pseries/power.c:55: warning: initialization from
incompatible pointer type
arch/powerpc/platforms/pseries/power.c:56: warning: initialization from
incompatible pointer type
arch/powerpc/platforms/pseries/power.c: In function `pm_init':
arch/powerpc/platforms/pseries/power.c:75: error: structure has no
member named `kset'
make[2]: *** [arch/powerpc/platforms/pseries/power.o] Error 1
make[1]: *** [arch/powerpc/platforms/pseries] Error 2
make: *** [arch/powerpc/platforms] Error 2
