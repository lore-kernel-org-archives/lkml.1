Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbXJJArX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbXJJArX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXJJArN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:47:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46669 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbXJJArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:47:12 -0400
Message-ID: <470C210C.6030800@pobox.com>
Date: Tue, 09 Oct 2007 20:47:08 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: thockin@hockin.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi: Use round_jiffies() for slow timers
References: <1191967059-7143-1-git-send-email-broonie@sirena.org.uk>
In-Reply-To: <1191967059-7143-1-git-send-email-broonie@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Unless we have failed to fill the RX ring the timer used by the natsemi
> driver is not particularly urgent and can use round_jiffies() to allow
> grouping with other timers.
> 
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> ---
>  drivers/net/natsemi.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)

ACK but does not apply to netdev-2.6.git#upstream or davem/net-2.6.24.git


