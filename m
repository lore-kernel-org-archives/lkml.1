Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbYKNCiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbYKNCiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYKNChu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:37:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44807
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYKNCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:37:49 -0500
Date: Thu, 13 Nov 2008 18:37:47 -0800 (PST)
Message-Id: <20081113.183747.184760657.davem@davemloft.net>
To: travis@sgi.com
Cc: paulus@samba.org, akpm@linux-foundation.org, yinghai@kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: David Miller <davem@davemloft.net>
In-Reply-To: <491CC8D7.7030306@sgi.com>
References: <491CC310.3050807@sgi.com>
	<20081113.162144.155677034.davem@davemloft.net>
	<491CC8D7.7030306@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Thu, 13 Nov 2008 16:39:51 -0800

> There's been a couple of different proposals to attempt to disassociate
> i/o and system vectors though even attempting to guess at the number of
> i/o devices is tricky.  Every one of the 512 nodes on a UV system *may*
> have a number of i/o devices attached to them though practically this
> will be rare. 

Practicality is what really matters.

We can even make the constant number a config option, so that if
someone has a system that actually triggers past this limit even dist
vendors can simply bump the config option value.
