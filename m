Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXIHMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXIHMCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXIHMCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 08:02:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:49200 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751532AbXIHMCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 08:02:32 -0400
Message-ID: <46E2900D.5010004@ru.mvista.com>
Date: Sat, 08 Sep 2007 16:05:33 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and
 SW/MW DMA mode masks (take 2)
References: <200709022344.18565.sshtylyov@ru.mvista.com>
In-Reply-To: <200709022344.18565.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once I quothed:

> Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While at it,
> make the udma_filter() method calls take precedence over using the mode masks.

    This one not looking to pretty -- I've geve some thought on how to 
beautify all these switch fallthoughs but haven't got something much better 
then uour original approach (AKA Occam's razor :-).

> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Farewell!
