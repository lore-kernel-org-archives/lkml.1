Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXJJArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXJJArl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXJJArY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:47:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46674 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbXJJArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:47:23 -0400
Message-ID: <470C2118.1060101@pobox.com>
Date: Tue, 09 Oct 2007 20:47:20 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: thockin@hockin.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi: Use NATSEMI_TIMER_FREQ consistently
References: <1191967059-7143-1-git-send-email-broonie@sirena.org.uk> <1191967059-7143-2-git-send-email-broonie@sirena.org.uk>
In-Reply-To: <1191967059-7143-2-git-send-email-broonie@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> The natsemi driver has a define NATSEMI_TIMER_FREQ which looks like it
> controls the normal frequency of the chip poll timer but in fact only
> takes effect for the first run of the timer.  Adjust the value of the
> define to match that used by the timer and use the define consistently.
> 
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> ---
>  drivers/net/natsemi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied


