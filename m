Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXC0BpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXC0BpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbXC0BpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:45:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60099
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933918AbXC0BpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:45:10 -0400
Date: Mon, 26 Mar 2007 18:45:08 -0700 (PDT)
Message-Id: <20070326.184508.85687849.davem@davemloft.net>
To: wli@holomorphy.com
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070327010624.GA2986@holomorphy.com>
References: <Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
	<20070326102651.6d59207b.akpm@linux-foundation.org>
	<20070327010624.GA2986@holomorphy.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
Date: Mon, 26 Mar 2007 18:06:24 -0700

> On Mon, Mar 26, 2007 at 10:26:51AM -0800, Andrew Morton wrote:
> > b) we understand why the below simple modification crashes i386.
> 
> Full eager zeroing patches not dependent on quicklist code don't crash,
> so there is no latent use-after-free issue covered up by caching. I'll
> help out more on the i386 front as-needed.

I've looked into this a few times and I am quite mystified as
to why that simple test patch crashes.
