Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbXLUAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbXLUAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760791AbXLUAGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:06:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759864AbXLUAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:06:04 -0500
Date: Thu, 20 Dec 2007 16:05:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: gallatin@myri.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NETDEV]: remove netif_running() check from
 myri10ge_poll()
Message-Id: <20071220160518.fa65ac90.akpm@linux-foundation.org>
In-Reply-To: <20071212.110243.202840959.davem@davemloft.net>
References: <47602AAA.8060204@myri.com>
	<20071212.110243.202840959.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 11:02:43 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Gallatin <gallatin@myri.com>
> Date: Wed, 12 Dec 2007 13:38:34 -0500
> 
> > Remove the bogus netif_running() check from myri10ge_poll().
> > 
> > This eliminates any chance that myri10ge_poll() can trigger
> > an oops by calling netif_rx_complete() and returning
> > with work_done == budget.
> > 
> > Signed-off-by: Andrew Gallatin <gallatin@myri.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

hm, eight days old, fixes a possible oops and hasn't been merged anywhere
yet?

I'll put it in my for-2.6.24-via-other-subsystem queue.
