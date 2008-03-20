Return-Path: <linux-kernel-owner+w=401wt.eu-S940820AbYCTAgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940820AbYCTAgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966072AbYCTAJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:09:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966063AbYCTAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:09:21 -0400
Date: Wed, 19 Mar 2008 17:09:37 -0700 (PDT)
Message-Id: <20080319.170937.247919863.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: drepper@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080319161211.2df88adc.akpm@linux-foundation.org>
References: <20080319020440.80379d50.akpm@linux-foundation.org>
	<a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	<20080319161211.2df88adc.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2008 16:12:11 -0700

> I did some work on that many years ago and I do recall that it
> helped, but I forget how much.

I wrote such a patch ages ago as well.

Frankly, based upon my experiences then and what I know now, I think
it's a lose to do this.

Better to 1) have enough ram and 2) make the reclaim smarter about
important "executable" page cache pages.
