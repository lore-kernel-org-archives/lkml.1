Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYEREzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYEREzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 00:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYEREzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 00:55:36 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:13523
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbYEREzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 00:55:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBABhTL0h8qN2q/2dsb2JhbAAIq3A
X-IronPort-AV: E=Sophos;i="4.27,503,1204470000"; 
   d="scan'208";a="222177683"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <200805171514.07619.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <20080428134649.44cf239c.akpm@linux-foundation.org>
	 <20080502203637.GG3956@ucw.cz>  <200805171514.07619.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Sun, 18 May 2008 14:55:36 +1000
Message-Id: <1211086536.3892.26.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-17 at 15:14 -0700, David Brownell wrote:
> On Friday 02 May 2008, Pavel Machek wrote:
> > What about mkdir gpio-N to export it?
> 
> Ugh.  That would create way more complication than I want
> to see here.  I thought about that early on, and decided
> that was Not The Way To Go.

I have a userspace gpio interface which uses /dev and configfs.  The
configfs side was really nice (and used mkdir, as configfs does) but I
wasn't a fan of needing udev..  On balance, I like the all-in-one sysfs
way more.

> 
> - Dave
> 
