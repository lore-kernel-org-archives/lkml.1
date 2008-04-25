Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYDYFRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYDYFRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYDYFR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:17:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47168 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYDYFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:17:28 -0400
Message-ID: <48116965.7030705@pobox.com>
Date: Fri, 25 Apr 2008 01:17:25 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 2/3] [libata/BF54x]: Fix bug - Implement bfin ata interrupt
 handler to avoid "irq 68 nobody cared"
References: <1209094676-20360-1-git-send-email-cooloney@kernel.org> <1209094676-20360-3-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209094676-20360-3-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Return IRQ_HANDLED when bfin ata device is busy.
> http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3513
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/ata/pata_bf54x.c |  125 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 121 insertions(+), 4 deletions(-)

AFAICS the two new functions you add should be (a) marked 'static' and 
(b) not marked 'inline'.

We avoid inline these days, preferring to let the compiler make the best 
choice for that platform/CPU.

	Jeff



