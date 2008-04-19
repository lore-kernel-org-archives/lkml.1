Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYDSBzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYDSBzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYDSByx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:54:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbYDSByv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:54:51 -0400
Date: Fri, 18 Apr 2008 18:54:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Message-Id: <20080418185443.7aa07ccf.akpm@linux-foundation.org>
In-Reply-To: <200804190115.15983.rusty@rustcorp.com.au>
References: <200804181433.48488.rusty@rustcorp.com.au>
	<200804181443.24812.rusty@rustcorp.com.au>
	<20080418043120.ff78eab5.akpm@linux-foundation.org>
	<200804190115.15983.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 01:15:15 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> It's not clear to me why this is in swap.c, but it exists
> even without CONFIG_SWAP, so that's OK.

We should have done mv mm/swap.c mm/mmlib.c years ago.
