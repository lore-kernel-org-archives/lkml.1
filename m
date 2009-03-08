Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZCHWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZCHWcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZCHWcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:32:41 -0400
Received: from h155.mvista.com ([63.81.120.155]:6087 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753794AbZCHWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:32:40 -0400
Message-ID: <49B44781.6050708@ru.mvista.com>
Date: Mon, 09 Mar 2009 01:32:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] ide: add ->dma_check method
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171229.25429.16478.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171229.25429.16478.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add (an optional) ->dma_check method for checking if DMA can be
>   used for a given command and fail DMA setup in ide_dma_prepare()
>   if necessary.
>
> * Convert alim15x3 and trm290 host drivers to use ->dma_check.
>
> * Rename ali15x3_dma_setup() to ali_dma_setup() while at it.
>   

   ali_dma_check() you mean?

> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


