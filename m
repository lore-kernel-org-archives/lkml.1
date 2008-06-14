Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYFNJn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYFNJn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYFNJnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:43:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38184 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbYFNJnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:43:14 -0400
Message-ID: <485392AE.7020501@garzik.org>
Date: Sat, 14 Jun 2008 05:43:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Peterson <cpeterso@cpeterso.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few
 uses of IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0806132238340.728@ikari.dreamhost.com>
In-Reply-To: <Pine.LNX.4.62.0806132238340.728@ikari.dreamhost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Peterson wrote:
> Remove network drivers' last few uses of theoretically-exploitable network
> entropy. Only 12 net drivers are affected. Headless boxes should use a
> more secure source of entropy, such as userspace daemons like rngd, 
> clrngd, audio_entropyd, and/or video_entroyd.
> 
> 
> Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>

For what it's worth...  I'm keeping this patch in my 'hold' queue, 
mainly to see if anyone really puts up some major objections, or fuss.

I'm leaning towards applying it for 2.6.27...

	Jeff



