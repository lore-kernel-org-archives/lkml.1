Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYHMRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYHMRLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYHMRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:10:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19786 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYHMRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XNUdgtrHZQHfU5gmmUyGgQJS6tI69Jq3Wbfb4XrtHTsrQ+uznVyQcltdmA2FNh6P9d
         Mo1Y8029rDXPM31jQeJGrG+HoryKppvOxmIU4Ij7LN4zKV7wKjncDVYz6FXOHgLL93xN
         u+lAEfA4RXK4tg+YGWT2wiJq090qWyZPe6PEE=
Message-ID: <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
Date: Thu, 14 Aug 2008 01:10:36 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080813141629.GD19397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:

> btw., could you please check that v2.6.27-rc3 (or later) kernels boot
> fine (with about 8 cpus) even if you have genericarch/bigsmp disabled,
> and do not silently hang as it happened on your box before?

With 16 CPUs, it still hangs, but now the console is showing the
errors as intended.
... but it is supposed to hang?

More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
Booting processor 8/1 ip 6000
Initializing CPU#8
Calibrating delay using timer specific routine.. 3723.88 BogoMIPS (lpj=7447763)
CPU: L1 I cache: 32Kb, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU8: Intel(8) Xeon(R) CPU        L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#8]: passed.
*** HANGS HERE ***

Thanks,
Jeff.
