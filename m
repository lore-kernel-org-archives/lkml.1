Return-Path: <linux-kernel-owner+w=401wt.eu-S939681AbXG3T7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939681AbXG3T7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938815AbXG3T72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:59:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33887 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937744AbXG3T71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:59:27 -0400
Message-ID: <46AE431D.2000808@garzik.org>
Date: Mon, 30 Jul 2007 15:59:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 mace_interrupt() in drivers/net/pcmcia/nmclan_cs.c
References: <46A567A8.6050409@gmail.com>
In-Reply-To: <46A567A8.6050409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference 
> DEV before a null check. This patch simply moves the dereferencing after 
> the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>

applied (git-am worked!)


