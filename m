Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYDBFkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYDBFkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 01:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYDBFk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 01:40:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:64462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYDBFk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 01:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SCyBA+RaG3uQMP8NseKFB5aBZfJ2f3d1MTZJV8mS6StFPcCnsdesDLfTzk86tw5/nV8NByYDQ1vxeAsZcNchjTK+XpL0B1o/USHkpbW9wDn5VRSf2jXdTxBzHSl52bkeQDZZ6SB26YpXWtyjnsKPnSR/7Sg5ft7ljTkrO0J06Bw=
Message-ID: <47F31C46.9000503@gmail.com>
Date: Wed, 02 Apr 2008 09:40:22 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
In-Reply-To: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

MIPS build fails with the following:

$ make ARCH=mips CROSS_COMPILE=mips-unknown-linux-gnu-
...
[skipped]
...
  CC      arch/mips/mips-boards/generic/init.o
In file included from include/asm/cacheflush.h:13,
                 from arch/mips/mips-boards/generic/init.c:30:
include/linux/mm.h:411:63: "NR_PAGEFLAGS" is not defined
include/linux/mm.h:459:62: "NR_PAGEFLAGS" is not defined
make[1]: *** [arch/mips/mips-boards/generic/init.o] Error 1
make: *** [arch/mips/mips-boards/generic] Error 2

Thanks,
Dmitri
