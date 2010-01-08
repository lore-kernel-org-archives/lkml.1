Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489Ab0AHGIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab0AHGIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902Ab0AHGId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:08:33 -0500
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:22799
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab0AHGId convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:08:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUBABdaRkt8qNTn/2dsb2JhbAAI1AaELwQ
X-IronPort-AV: E=Sophos;i="4.49,240,1262534400"; 
   d="scan'208";a="594767451"
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
Date: Fri, 8 Jan 2010 17:08:28 +1100
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A780F468-EA15-49EA-83B4-D472E92CA91A@niasdigital.com>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/01/2010, at 4:14 PM, Eric Miao wrote:

> commit 29cd35f57699fd93a12132186d52109a55ed57e7
> Author: Eric Miao <eric.y.miao@gmail.com>
> Date:   Fri Jan 8 12:16:28 2010 +0800
> 
>    gpio: introduce gpio_request_one() and friends
> 
>    gpio_request() without initial configuration of the GPIO is normally
>    useless, introduce gpio_request_one() together with GPIOF_ flags for
>    input/output direction and initial output level.

Well yea it is useless without initial configuration but I've always done that configuration before any gpiolib calls.  The initial direction and state stuff really has to be set up and pin-mux or gpio-chip-activate time otherwise it'll glitch; by the time we get to gpio_request time I've got everything just how I like it and just want the refcount aspect of gpio_request.

I'm obviously thinking in a very small-minded platform-gpio-only kind of a way, what system have you got which uses this (and how does it not glitch)?

Thanks,
	--Ben.

