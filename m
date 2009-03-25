Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZCYCtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZCYCtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZCYCtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:49:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45719 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCYCtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:49:01 -0400
Message-ID: <49C99B98.30008@garzik.org>
Date: Tue, 24 Mar 2009 22:48:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/4] libata: Drain data on errors
References: <20090324101952.9152.30261.stgit@localhost.localdomain> <20090324102230.9152.26655.stgit@localhost.localdomain>
In-Reply-To: <20090324102230.9152.26655.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
> 
> If the device is signalling that there is data to drain after an error we
> should read the bytes out and throw them away. Without this some devices
> and controllers get wedged and don't recover.
> 
> Based on earlier work by Mark Lord
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/ata/libata-sff.c  |   45 +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/ata/pata_pcmcia.c |   34 +++++++++++++++++++++++++++++++++-
>  include/linux/libata.h    |    3 +++
>  3 files changed, 79 insertions(+), 3 deletions(-)

applied


