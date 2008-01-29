Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYA2FuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYA2FuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYA2Ft5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:49:57 -0500
Received: from ozlabs.org ([203.10.76.45]:53458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYA2Ft5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:49:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [Patch] Removal of FUTEX_FD
Date: Tue, 29 Jan 2008 13:55:37 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080125094046.GA4494@alice>
In-Reply-To: <20080125094046.GA4494@alice>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291355.38121.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 20:40:46 Eric Sesterhenn wrote:
> hi,
>
> since FUTEX_FD was scheduled for removal in June 2007 lets remove it.
> Google Code search found no users for it and NGPT was abandoned in 2003
> according to IBM. futex.h is left untouched to make sure the id does
> not get reassigned. Since queue_me() has no users left it is commented
> out to avoid a warning, i didnt remove it completely since it is part
> of the internal api (matching unqueue_me())

Thanks, I've queued this with a futher cleanup (rename __queue_me to queue_me, 
add comments, and remove the old one entirely).

Thanks,
Rusty.
