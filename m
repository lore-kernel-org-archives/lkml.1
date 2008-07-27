Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYG0Xon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYG0Xon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 19:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYG0Xoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 19:44:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36961 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbYG0Xoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 19:44:34 -0400
X-Sasl-enc: vXNqpi2m+Q4haM3388UV9pYYXGsHNlnSUp7+zScQvKzh 1217202272
Message-ID: <488D0806.8020407@whitby.id.au>
Date: Mon, 28 Jul 2008 09:13:02 +0930
From: Rod Whitby <rod@whitby.id.au>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Sven Wegener <sven.wegener@stealer.net>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-fsg: Change order of initialization and deinitialization
References: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net>
In-Reply-To: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Wegener wrote:
> On initialization, we first do the ioremap and then register the led devices.
> On deinitialization, we do it in reverse order. This prevents someone calling
> into the brightness_set functions with an invalid latch_address.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Cc: Rod Whitby <rod@whitby.id.au>

Acked-by: Rod Whitby <rod@whitby.id.au>

Thanks.

-- Rod
