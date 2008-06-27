Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYF0GIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYF0GIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYF0GIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:08:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50240 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYF0GIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:08:20 -0400
Message-ID: <486483CE.8010305@garzik.org>
Date: Fri, 27 Jun 2008 02:08:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 2/3] e1000: remove PCI Express device IDs
References: <20080622221916.5907.79563.stgit@localhost.localdomain> <20080622222021.5907.16668.stgit@localhost.localdomain>
In-Reply-To: <20080622222021.5907.16668.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: Auke Kok <auke-jan.h.kok@intel.com>
> 
> We do not want to prolong the situation much longer that e1000
> and e1000e support these devices at the same time. As a result,
> take out the bandage that was added for the interim period
> and remove all the PCI Express device IDs from e1000.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
> 
>  drivers/net/Kconfig            |    3 ---
>  drivers/net/e1000/e1000_main.c |   33 ---------------------------------
>  2 files changed, 0 insertions(+), 36 deletions(-)

applied to #upstream-next (queued for 2.6.27)

BIG FLASHING WARNING NOTE to x86 maintainers and others:

Make sure your defconfig changes are in place for this change.


