Return-Path: <linux-kernel-owner+w=401wt.eu-S1030698AbXCNJJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698AbXCNJJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXCNJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:09:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030698AbXCNJJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:09:29 -0400
Message-ID: <45F7BBAA.2000109@garzik.org>
Date: Wed, 14 Mar 2007 05:08:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/13] zatm __init abuse
References: <E1HRPPp-0001v3-Oq@ZenIV.linux.org.uk>
In-Reply-To: <E1HRPPp-0001v3-Oq@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> zatm_init() and zatm_start() should be __devinit (the former is
> not module init, despite the name - it's a helper for PCI ->probe())
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/atm/zatm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

ACK


