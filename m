Return-Path: <linux-kernel-owner+w=401wt.eu-S1764249AbXJQNyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764249AbXJQNyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXJQNyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:54:33 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:51213 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXJQNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:54:31 -0400
Message-ID: <47161415.3020502@tiscali.nl>
Date: Wed, 17 Oct 2007 15:54:29 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl> <471612E1.2050907@tiscali.nl>
In-Reply-To: <471612E1.2050907@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
>     if(!x & y) should either be if(!(x & y)) or if(!x && y)
>     I made changes as seemed appropriate, but please review
>     
>     several changes to drivers/net/
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> 
hmmm forgot to place '---' here, should I resend?
> diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
> index cf70522..14141a5 100644
> --- a/drivers/net/e1000e/82571.c
> +++ b/drivers/net/e1000e/82571.c


