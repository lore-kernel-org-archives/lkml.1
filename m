Return-Path: <linux-kernel-owner+w=401wt.eu-S1761165AbZFXTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165AbZFXTfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZFXTfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:35:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZFXTfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:35:07 -0400
Message-ID: <4A42800D.6020202@garzik.org>
Date: Wed, 24 Jun 2009 15:35:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw, greg@kroah.com,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Try this version instead - forgot to refresh the patch before sending
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/ata/Kconfig    |   10 +
>  drivers/ata/Makefile   |    1 
>  drivers/ata/pata_rdc.c |  400 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 411 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/pata_rdc.c

Requesting that linux-ide be CC'd in the future, for this driver...

Seems fine and fairly straightforward to me.  My lone comment -- go 
through and replace magic numbers with named constants, for e.g. the PCI 
config registers that program timings...

	Jeff



