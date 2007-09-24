Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbXIXMkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbXIXMkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbXIXMka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:40:30 -0400
Received: from homer.mvista.com ([63.81.120.155]:6312 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752619AbXIXMk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:40:29 -0400
Message-ID: <46F7B117.5000202@ru.mvista.com>
Date: Mon, 24 Sep 2007 16:44:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and
 SW/MW DMA mode masks (take 2)
References: <200709022344.18565.sshtylyov@ru.mvista.com> <46E2900D.5010004@ru.mvista.com>
In-Reply-To: <46E2900D.5010004@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once I quothed:

>> Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While 
>> at it,
>> make the udma_filter() method calls take precedence over using the 
>> mode masks.

>    This one not looking to pretty -- I've geve some thought on how to 
> beautify all these switch fallthoughs but haven't got something much 
> better then uour original approach (AKA Occam's razor :-).

    So, it's probably better forget about this patch. But please do take patch 
4/4 to merge either before or after your "Occam's razor" -- it makes its best 
at masking out the MWDMA modes anyways...

Farewell!
