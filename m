Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbXFMTkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbXFMTkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXFMTju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:39:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38834 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbXFMTjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:39:49 -0400
Message-ID: <46704801.1070107@garzik.org>
Date: Wed, 13 Jun 2007 15:39:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Blackfin ethernet driver: on chip ethernet MAC controller
 driver
References: <1179912533.10328.26.camel@roc-desktop>
In-Reply-To: <1179912533.10328.26.camel@roc-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: "Wu, Bryan" <bryan.wu@analog.com>
> 
> This patch implements the driver necessary use the Analog Devices
> Blackfin processor's on-chip ethernet MAC controller.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/Kconfig    |   44 +
>  drivers/net/Makefile   |    1 
>  drivers/net/bfin_mac.c |  981 +++++++++++++++++++++++++++++++++++++++
>  drivers/net/bfin_mac.h |  147 +++++
>  4 files changed, 1173 insertions(+)

Finally got back to this.  Please run this patch through 
scripts/checkpatch.pl (found in latest linux-2.6.git upstream kernel 
tree), and follow most of the recommendations.

Personally I would ignore the lines slightly over 80 columns, but the 
other warnings look like real issues.

	Jeff



