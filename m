Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbYFRD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbYFRD0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758375AbYFRD0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:26:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40551 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbYFRD0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:26:30 -0400
Message-ID: <48588063.4020304@garzik.org>
Date: Tue, 17 Jun 2008 23:26:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: netdev@vger.kernel.org, Claudio Lanconelli <lanconelli.claudio@eptar.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND #3/patch 2.6.26-rc6] net/enc28j60: low power mode
References: <200806122138.06674.david-b@pacbell.net>
In-Reply-To: <200806122138.06674.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Keep enc28j60 chips in low-power mode when they're not in use.
> At typically 120 mA, these chips run hot even when idle; this
> low power mode cuts that power usage by a factor of around 100.
> 
> This version provides a generic routine to poll a register until
> its masked value equals some value ... e.g. bit set or cleared.
> It's basically what the previous wait_phy_ready() did, but this
> version is generalized to support the handshaking needed to
> enter and exit low power mode.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Claudio Lanconelli <lanconelli.claudio@eptar.com>
> ---
> Previously sent:  18-May, 19-February; there were several
> previous iterations too ...
> 
>  drivers/net/enc28j60.c |   82 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 58 insertions(+), 24 deletions(-)

applied


