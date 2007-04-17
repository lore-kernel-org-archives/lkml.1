Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXDQPEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXDQPEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXDQPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:04:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39976 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbXDQPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:04:08 -0400
Message-ID: <4624E1E6.7050501@garzik.org>
Date: Tue, 17 Apr 2007 11:04:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] libata: allocate ap separately from shost
References: <1176821046841-git-send-email-htejun@gmail.com>
In-Reply-To: <1176821046841-git-send-email-htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Don't embed ap inside shost.  Allocate it separately and point it back
> from shosts's hostdata.  This makes port allocation more flexible and
> allows regular ATA and SAS share host alloc/init paths.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/ata/libata-core.c |   19 ++++++++++++++-----
>  include/linux/libata.h    |    2 +-
>  2 files changed, 15 insertions(+), 6 deletions(-)

applied patches 1-12 to #upstream.

Yay, libata init model is finally clean!

Thanks,

	Jeff


