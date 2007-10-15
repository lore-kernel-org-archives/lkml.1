Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbXJOP4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbXJOP4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXJOPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:55:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbXJOPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:55:54 -0400
Date: Mon, 15 Oct 2007 08:55:41 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Komuro <komurojun-mbn@nifty.com>
Cc: shemminger@linux.foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE]     [TCP]: Set initial_ssthresh default to zero
 in Cubic and BIC.
Message-ID: <20071015085541.48ec63ae@freepuppy.rosehill>
In-Reply-To: <20071015215949.50399c00.komurojun-mbn@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
	<20071014100245.914b784a.komurojun@nifty.com>
	<20071014132851.8d6a9de3.komurojun@nifty.com>
	<20071014135356.19754635.komurojun-mbn@nifty.com>
	<20071015215949.50399c00.komurojun-mbn@nifty.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 21:59:49 +0900
Komuro <komurojun-mbn@nifty.com> wrote:

> Dear shemminger
> 
> >In which case it is zero because that is the default value.
> 
> The default value of snd_ssthresh is 0x7fffffff, isn't it?
> 
> [linux/net/ipv4/tcp_ipv4.c]
> static int tcp_v4_init_sock(struct sock *sk)
> ...
>         tp->snd_ssthresh = 0x7fffffff;  /* Infinity */
> ...
> 
> Best Regards
> Komuro
> 
> 

Yes that value means that TCP stays in slow start until the first loss.
This makes TCP behave as expected in the RFC's.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
