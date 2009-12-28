Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZL1Q04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZL1Q04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZL1Q0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:26:55 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51079 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZL1Q0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:26:55 -0500
Date: Tue, 29 Dec 2009 00:26:48 +0800
From: Yin Kangkai <kernel@holddreams.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [mmotm] ramzswap: add handlers for various swap
	events
Message-ID: <20091228162648.GA29309@kai-nas>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <1261963200-7136-2-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261963200-7136-2-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-12-28, 06:50 +0530, Nitin Gupta wrote:
> +	ret = register_swap_event_notifier(&ramzswap_swapon_nb,
> +				SWAP_EVENT_SWAPON, 0);
> +	if (ret) {
> +		pr_err("Error registering swapon notifier\n");
> +		goto out;
> +	}
> +
> +	ret = register_swap_event_notifier(&ramzswap_swapoff_nb,
> +				SWAP_EVENT_SWAPOFF, 0);
> +	if (ret) {

Sorry, but an unregister here?

> +		pr_err("Error registering swapoff notifier\n");
> +		goto out;
> +	}
> +
