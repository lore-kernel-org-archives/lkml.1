Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYH0J4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYH0J4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYH0J4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:56:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYH0J4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:56:17 -0400
Message-ID: <48B524BA.9010401@pobox.com>
Date: Wed, 27 Aug 2008 05:56:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>
Subject: Re: [PATCH 1/1] NET: e100, fix iomap read
References: <1218731243-32732-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1218731243-32732-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> There were 2 omitted readb's used on an iomap space. eliminate them
> by using ioread8 instead.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> Cc: John Ronciak <john.ronciak@intel.com>
> ---
>  drivers/net/e100.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied


