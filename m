Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYDZX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYDZX2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDZX2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:28:37 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:47545
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbYDZX2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:28:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AucAANZXE0h8qMj2/2dsb2JhbAAIqX0
X-IronPort-AV: E=Sophos;i="4.25,712,1199631600"; 
   d="scan'208";a="320765823"
Subject: Re: [PATCH] Give gpiolib an implementation of gpio_is_valid()
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200804260912.39970.david-b@pacbell.net>
References: <1209207781.3756.120.camel@moss.renham>
	 <200804260912.39970.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Sun, 27 Apr 2008 09:28:28 +1000
Message-Id: <1209252508.3756.122.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-26 at 09:12 -0700, David Brownell wrote:
> On Saturday 26 April 2008, Ben Nizette wrote:
> > Platforms which use generic (NOP) gpio routines get an implementation of
> > gpio_is_valid() (in linux/gpio.h) but the people who actually use gpio
> > don't get one.  Roll an implementation for gpiolib based on
> > gpio_request(); this ought to do for most people.
> 
> There's already a gpio_is_valid() patch in the MM merge queue;
> it comes with the documentation, and covers implementations which
> include the <asm-generic/gpio.h> header (for cansleep stubs) but
> don't use gpiolib.
> 
> So, please wait till RC1, by which time I expect Andrew's queue
> will be relatively depleted.  :)
> 
Righteo, thanks and sorry for being impatient :-)

	--Ben.

