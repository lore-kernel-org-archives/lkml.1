Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZBTOZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZBTOZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZBTOZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:25:27 -0500
Received: from svb-lan-93.maglan.ru ([62.64.8.93]:40443 "EHLO
	zimbra.svb.sbrf.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZBTOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:25:26 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 09:25:25 EST
X-Spam-Flag: NO
X-Spam-Score: -3.368
Message-ID: <499EBAC6.60804@sbmag.ru>
Date: Sat, 21 Feb 2009 01:14:30 +1100
From: zaharov <zaharov@sbmag.ru>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: Matias <linux@sundmangroup.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SMP Kernel
References: <499EB742.4050208@sundmangroup.com>
In-Reply-To: <499EB742.4050208@sundmangroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matias wrote:
> Hello,
> When an SMP enabled kernel is booted on a Dual Core x86 machine ( Core
> 0-1 ) I guess the Kernel is decompressed and started on core 0.
> At some point in time the kernel becomes SMP aware and can then
> distribute threads on Cores 0 and 1.
>
> Now, does the non-threaded part of the kernel with the scheduler
> continue to run solely on Core 0?
>
> Cheers // Matias
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Kernel may run on any core .
When kernel end bootstrap and run init he execute hlt op.
After all live in kernel  interrupt driven.

