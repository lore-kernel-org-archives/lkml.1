Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYD2GTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYD2GTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYD2GSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:18:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51629 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYD2GSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:18:52 -0400
Message-ID: <4816BDC4.7050805@pobox.com>
Date: Tue, 29 Apr 2008 02:18:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/1] [libata/BF54x]: Fix bug - Implement bfin ata interrupt
 handler to avoid "irq 68 nobody cared" (v2)
References: <1209115165-24995-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209115165-24995-1-git-send-email-cooloney@kernel.org>
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
> v1-v2:
>  - fold api breakage fixing patch together.
>  - mark 'static', not 'inline'.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/ata/pata_bf54x.c |  124 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 120 insertions(+), 4 deletions(-)

applied


