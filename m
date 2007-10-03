Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXJCRkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXJCRkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXJCRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:40:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55089 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXJCRj7 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:39:59 -0400
Message-ID: <4703D3E6.4080003@pobox.com>
Date: Wed, 03 Oct 2007 13:39:50 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: pomac@vapor.com, Linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: jumbo frame regression fix
References: <1191372129.26233.12.camel@localhost> <20071002180209.47c350a3@freepuppy.rosehill>
In-Reply-To: <20071002180209.47c350a3@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Remove unneeded check that caused problems with jumbo frame sizes.
> The check was recently added and is wrong.
> When using jumbo frames the sky2 driver does fragmentation, so
> rx_data_size is less than mtu.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

applied


