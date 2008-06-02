Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYFBLn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYFBLn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbYFBLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:43:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:38561 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755936AbYFBLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:43:15 -0400
Message-ID: <4843DCCD.6080600@ru.mvista.com>
Date: Mon, 02 Jun 2008 15:43:09 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/21] ide: remove unused XFER_UDMA_SLOW
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain> <20080528214002.16327.28489.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528214002.16327.28489.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Remove unused XFER_UDMA_SLOW from ide_timing[].

> While at it:

> - fix re-defining XFER_PIO_5 (no need to define it in ide-timing.h as
>   it is defined in <linux/ata.h> which is included by <linux/hdreg.h>)

> - fix whitespace damage

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
