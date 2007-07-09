Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbXGID0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbXGID0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXGIDZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:25:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44472 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbXGIDZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:25:52 -0400
Message-ID: <4691AABE.5030609@pobox.com>
Date: Sun, 08 Jul 2007 23:25:50 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 free_shared_mem() in drivers/net/s2io.c
References: <aaab98560707082024v106a61c1r501ef9817e029410@mail.gmail.com>
In-Reply-To: <aaab98560707082024v106a61c1r501ef9817e029410@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference 
> nic before a null check. This patch simply moves the dereferencing after 
> the null check.
> 
> Signed-off-by: Micah Gruber < micah.gruber@gmail.com 
> <mailto:micah.gruber@gmail.com>>

any chance you can resend in an email format other than format=flowed?

	Jeff



