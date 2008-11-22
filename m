Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbYKVNR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbYKVNR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 08:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbYKVNRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 08:17:18 -0500
Received: from [63.81.120.155] ([63.81.120.155]:22250 "EHLO imap.sh.mvista.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757631AbYKVNRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 08:17:17 -0500
Message-ID: <49280658.9080606@ru.mvista.com>
Date: Sat, 22 Nov 2008 16:17:12 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: add ->max_sectors field to struct ide_port_info
References: <200811212242.08182.bzolnier@gmail.com>
In-Reply-To: <200811212242.08182.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Add ->max_sectors field to struct ide_port_info to allow host drivers
>   to specify value used for hwif->rqsize (if smaller than the default).
>
> * Convert pdc202xx_old to use ->max_sectors and remove no longer needed
>   IDE_HFLAG_RQSIZE_256 flag.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtyltov <sshtylyov@ru.mvista.com>

MBR, Sergei


