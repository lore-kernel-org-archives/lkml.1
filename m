Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXEJOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXEJOIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXEJOIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:08:40 -0400
Received: from khc.piap.pl ([195.187.100.11]:45653 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXEJOIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:08:39 -0400
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.3 - QMGR
References: <m3vef5biob.fsf@maximus.localdomain>
	<5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk>
	<m3hcqoa772.fsf@maximus.localdomain>
	<86D26EBE-5899-468F-9C79-23E83E0DE04B@cam.ac.uk>
	<m33b289zku.fsf@maximus.localdomain>
	<m31whs5ehn.fsf_-_@maximus.localdomain>
	<20070508113232.GA32055@xi.wantstofly.org>
	<m3k5vj76bi.fsf@maximus.localdomain>
	<20070508144001.GC387@xi.wantstofly.org>
	<m3ps5b5k07.fsf@maximus.localdomain>
	<20070509102136.GG6976@xi.wantstofly.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 10 May 2007 16:08:35 +0200
In-Reply-To: <20070509102136.GG6976@xi.wantstofly.org> (Lennert Buytenhek's message of "Wed, 9 May 2007 12:21:36 +0200")
Message-ID: <m38xbwydng.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek <buytenh@wantstofly.org> writes:

> The way I see it, that means that you do want to scale back your
> other SRAM allocations if you know that you're going to need a lot
> of SRAM (say, for ethernet RX/TX queues.)

Yep, I will then add "queue_size" parameter to the platform data.
Or something like that.

> Or you can put this knowledge in the board support code (cleaner, IMHO.)

Sure.

> That way, you can _guarantee_ that you'll always have enough SRAM
> to be able to use the functionality that is exposed on the board you
> are running on (which is a desirable property, IMHO), which is
> something that you can't achieve with an allocator, as far as I can
> see.

I'd have to put SRAM address in the board code instead. Certainly
not required at this point, and perhaps it will be never needed.
-- 
Krzysztof Halasa
