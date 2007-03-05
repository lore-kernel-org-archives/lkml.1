Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXCEUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXCEUvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXCEUvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:51:44 -0500
Received: from waste.org ([66.93.16.53]:48441 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbXCEUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:51:43 -0500
Date: Mon, 5 Mar 2007 14:38:57 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: [PATCH] [RSDL 5/6] sched: implement rsdl cpu scheduler
Message-ID: <20070305203857.GQ16722@waste.org>
References: <200703041806.22965.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703041806.22965.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 06:06:22PM +1100, Con Kolivas wrote:
> + * This is the time all tasks within the same priority round robin.
> + * Set to a minimum of 6ms.
>   */
> +#define RR_INTERVAL		((6 * HZ / 1001) + 1)

What happens with small HZ? Like 100? I suppose 10ms is a reasonable
number here. But in general, how well does this scheduler do without a
time source other than jiffies?

-- 
Mathematics is the supreme nostalgia of our time.
