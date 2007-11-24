Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXKXDKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXKXDKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXKXDKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:10:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44365 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbXKXDKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:10:38 -0500
Message-ID: <4747962D.5010506@garzik.org>
Date: Fri, 23 Nov 2007 22:10:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Linux Netdev List <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NET: dmfe: don't access configuration space in D3 state
References: <200711230129.02570.maximlevitsky@gmail.com> <200711230130.15939.maximlevitsky@gmail.com>
In-Reply-To: <200711230130.15939.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
>>From 7e24227257f315e52fe0b494dc1253d2a0ce5dff Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 23 Nov 2007 01:15:36 +0200
> Subject: [PATCH] NET: dmfe: don't access configuration space in D3 state
>  Accidently I reversed the order of pci_save_state and
>  pci_set_power_state in .suspend()/.resume() callbacks
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/net/tulip/dmfe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

applied #upstream-fixes, after hand-editing patch changelog taking by 
git-am from email body


