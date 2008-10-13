Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYJMDpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYJMDpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYJMDpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:45:24 -0400
Received: from 1wt.eu ([62.212.114.60]:4738 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYJMDpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:45:24 -0400
Date: Mon, 13 Oct 2008 05:44:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call mechanism
Message-ID: <20081013034414.GN24654@1wt.eu>
References: <20081012194427.2e21c22e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012194427.2e21c22e@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Sun, Oct 12, 2008 at 07:44:27PM -0400, Arjan van de Ven wrote:
> +#define ASYNC_POOL_SCSI	 0	/* for everything using the scsi device space */
> +#define ASYNC_POOL_IDE	 1	/* for everything using the ide device space */
> +#define ASYNC_POOL_USB	 2	/* for everything using the usb device space */
> +#define ASYNC_POOL_MISC	 4	/* for everything using the misc device space */
> +#define ASYNC_POOL_SOUND 5	/* for everything using the ALSA device space */
> +#define ASYNC_POOL_AGP   6	/* for everything using the AGP device space */
> +#define ASYNC_MAX_POOL	 7

I suspect this list will grow with more general adoption. Wouldn't it be
better to use an enum above ?

Willy

