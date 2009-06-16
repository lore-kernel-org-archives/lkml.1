Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZFPIXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZFPIXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZFPIXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:23:07 -0400
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:34815 "HELO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915AbZFPIXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <20090616171029H.fujita.tomonori@lab.ntt.co.jp>
References: <2e115de50906160024r7c3140d6sc8744e4362d36ef8@mail.gmail.com>
	 <20090616171029H.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 16 Jun 2009 17:53:03 +0930
Message-ID: <2e115de50906160123n20791768sd154621b0d95ca50@mail.gmail.com>
Subject: Re: is_device_dma_capable
From: Malcom Blaney <malcolm.blaney@maptek.com.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fujita,

2009/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> You use X86_32, right?

I have CONFIG_X86_32=y in my config file.

>
> In 2.6.25, X86_32 and X86_64 had the own dma_alloc_coherent
> implementations; X86_32 accepted a device having dma_mask that is not
> initialized however X86_64 didn't, I think.
>
> When we merged them, we chose to prohibit a device having dma_mask
> that is not initialized. I'm not sure the DMA docs say this but IMO
> it's good to require drivers to set up dma_mask (and
> coherent_dma_mask) properly if the drivers want DMA.
>

If you could point me in the direction of how to set these values
correctly, I would appreciate it.

thanks,
Malcolm.
