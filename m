Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXIBTI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXIBTI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXIBTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:08:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:54370 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751094AbXIBTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:08:20 -0400
Message-ID: <46DB0ACB.2080704@ru.mvista.com>
Date: Sun, 02 Sep 2007 23:11:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and
 SW/MW DMA mode masks
References: <200709022306.16560.sshtylyov@ru.mvista.com>
In-Reply-To: <200709022306.16560.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

> Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While at it,
> make the udma_filter() method calls take precedence over using the mode masks.
> 
> ---
> This version doesn't use explicit UltraDMA masks, so converting them to the
> ATA_UDMA* is left for another, global patch.

    Argh, ignore the above sentense.

> This patch against the current
> Linus' tree and unfortunately I was able to only compile test it since that
> tree gives MODPOST warning and dies early on bootup.

    This is still so. I'll try to test it whenever I have enought time...

MBR, Sergei
