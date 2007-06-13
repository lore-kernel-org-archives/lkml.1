Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXFMTqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXFMTqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXFMTp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:45:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38905 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXFMTp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:45:57 -0400
Message-ID: <46704972.5020900@garzik.org>
Date: Wed, 13 Jun 2007 15:45:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: notting@redhat.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: fix comparisons of unsigned < 0
References: <20070530075902.GA29118@nostromo.devel.redhat.com>
In-Reply-To: <20070530075902.GA29118@nostromo.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham wrote:
> Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>
> 
> ---
>  mlx4/qp.c               |    3 +--
>  netxen/netxen_nic_niu.c |    6 +++---
>  tulip/de2104x.c         |    1 -
>  3 files changed, 4 insertions(+), 6 deletions(-)

applied to #upstream (2.6.23)

BTW please fix your Mail-Followup-To header


