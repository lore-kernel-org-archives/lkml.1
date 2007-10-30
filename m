Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbXJ3SdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbXJ3SdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXJ3Sco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:32:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60766 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXJ3Scn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:32:43 -0400
Message-ID: <472778C9.5040408@garzik.org>
Date: Tue, 30 Oct 2007 14:32:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] Blackfin EMAC driver: Fix Ethernet communication
 bug (dupliated and lost packets)
References: <1193735049-7070-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1193735049-7070-1-git-send-email-bryan.wu@analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Fix Ethernet communication bug(dupliated and lost packets)
> in RMII PHY mode- dont call mac_disable and mac_enable during
> 10/100 REFCLK changes - mac_enable screws up the DMA descriptor chain
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/net/bfin_mac.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

applied


