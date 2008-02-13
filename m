Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYBMVS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYBMVS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYBMVSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:18:50 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:48995 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYBMVSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:18:49 -0500
Date: Thu, 14 Feb 2008 00:18:54 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: rth@twiddle.net, rmk@arm.linux.org.uk, bryan.wu@analog.com,
       dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 2/2] xtime_lock vs update_process_times
Message-ID: <20080213211854.GA2853@jurassic.park.msu.ru>
References: <20080128103953.326762000@chello.nl> <20080128104056.184943000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128104056.184943000@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 11:39:55AM +0100, Peter Zijlstra wrote:
> move update_process_times() out from under xtime_lock.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/alpha/kernel/time.c              |   15 ++++++++-------

This indeed fixes deadlock on alpha, so this part

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
