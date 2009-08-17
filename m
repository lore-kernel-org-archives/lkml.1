Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZHQJOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZHQJOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZHQJOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:14:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:25714 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbZHQJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SaTK2Q2+VXeJH9wNQRqiVgbKrTxqzovxouqPqAlh6NcqCctCYoukAOEOF9H1IoMo0V
         QwrprrqZDoTjZkHS5UPviEBQ+DbiCJfEmelkgHntfqptEKZ69/kTQ7dyErkRY0faAwAo
         15Ye+KhbUBct7ciZnR5Mje4GAdr+NNhAOeXKM=
Date: Mon, 17 Aug 2009 12:16:01 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] ARM: OMAP: DMA: Add support for DMA channel
 self linking on OMAP1510
Message-Id: <20090817121601.2fdb0c0f.jhnikula@gmail.com>
In-Reply-To: <200908101050.02530.jkrzyszt@tis.icnet.pl>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 10:50:00 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> Implement DMA channel self linking on OMAP1510 using AUTO_INIT and REPEAT
> flags of the DMA CCR register.
> 
> Created against linux-2.6.31-rc5.
> 
> Tested on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
Tony, I'm fine with this patch. Although the autoinitialization !=
channel linking, in SW point of view autoinitialization and channel
linking with itself looks the same so it's better to re-utilize
existing omap_dma_link_lch also for 1510 DMA autoinitialization than
inventing own API for it.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
