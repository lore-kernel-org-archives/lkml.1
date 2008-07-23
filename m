Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYGWUtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYGWUtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYGWUtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:49:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52634 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYGWUs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:48:59 -0400
Message-ID: <48879938.8010803@pobox.com>
Date: Wed, 23 Jul 2008 16:48:56 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: add missing ATA_ID_* defines (take 2)
References: <200807222249.32242.bzolnier@gmail.com>
In-Reply-To: <200807222249.32242.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Add missing ATA_ID_* defines and update {ata,atapi}_*()
> inlines accordingly.  The currently unused defines are
> needed for the forthcoming drivers/ide/ changes.
> 
> v2:
> Add ATA_ID_SPG.
> 
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> v2 was needed because one define got lost :/
> 
>  include/linux/ata.h |  122 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 76 insertions(+), 46 deletions(-)

ACK, and I'll send this one upstream myself.  It shouldn't conflict with 
the patches just ACK'd.


