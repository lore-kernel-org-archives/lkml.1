Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYLEHIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYLEHIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYLEHId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:08:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbYLEHIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:08:32 -0500
Date: Thu, 4 Dec 2008 23:08:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Flags should be accessed via the foo_bit
 interfaces
Message-Id: <20081204230823.bdb78508.akpm@linux-foundation.org>
In-Reply-To: <20081204154030.27980.82380.stgit@localhost.localdomain>
References: <20081204154030.27980.82380.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2008 15:41:19 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> --- a/drivers/net/slip.c
> +++ b/drivers/net/slip.c
> @@ -432,7 +432,7 @@ static void slip_write_wakeup(struct tty_struct *tty)
>  		/* Now serial buffer is almost free & we can start
>  		 * transmission of another packet */
>  		sl->tx_packets++;
> -		tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
> +		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);

that's different.
