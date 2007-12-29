Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbXL2Nyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbXL2Nyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXL2Nyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:54:44 -0500
Received: from h155.mvista.com ([63.81.120.155]:12034 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753347AbXL2Nyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:54:43 -0500
Message-ID: <477651BE.90400@ru.mvista.com>
Date: Sat, 29 Dec 2007 16:55:10 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 7/9] icside: use hwif->dev
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain> <20071227191245.1357.38374.sendpatchset@localhost.localdomain> <47765111.9030303@ru.mvista.com>
In-Reply-To: <47765111.9030303@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:

>> * Setup hwif->dev in icside_setup().

>> * Use hwif->dev instead of state->dev in icside_build_sglist(),
>>   icside_dma_end(), icside_dma_start() and icside_dma_setup().

>> * Remove no longer needed 'dev' field from struct icside_state.

>> Cc: Russell King <rmk@arm.linux.org.uk>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    Hmm, it looks like I've already reviewed this patch... :-/

MBR, Sergei
