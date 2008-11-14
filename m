Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYKNDG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYKNDG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKNDGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:06:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39523 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751143AbYKNDGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:06:18 -0500
Message-ID: <491CEB23.80403@sgi.com>
Date: Thu, 13 Nov 2008 19:06:11 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulus@samba.org, akpm@linux-foundation.org, yinghai@kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491CC310.3050807@sgi.com>	<20081113.162144.155677034.davem@davemloft.net>	<491CC8D7.7030306@sgi.com> <20081113.183747.184760657.davem@davemloft.net>
In-Reply-To: <20081113.183747.184760657.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> Practicality is what really matters.
> 
> We can even make the constant number a config option, so that if
> someone has a system that actually triggers past this limit even dist
> vendors can simply bump the config option value.

Unfortunately the reality is that distros spend months certifying the base
kernel for both application and security conformance.  And many (most?) of
the large system customers will only run this kernel.  Even changing root
startup options is considered invalidating the conformance testing.  That
means the kernel has to adapt to the resource needs of the system being
serviced.

Ideally, linux shouldn't have any fixed resources.  A system built to run
on a massively parallel system should also boot and run on a smart phone
(not well perhaps... ;-)
