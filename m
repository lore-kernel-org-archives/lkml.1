Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYIJXYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYIJXYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYIJXYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:24:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754975AbYIJXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:24:29 -0400
Date: Wed, 10 Sep 2008 16:24:23 -0700 (PDT)
Message-Id: <20080910.162423.40167601.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221088512.13621.58.camel@macbook.infradead.org>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	<20080910.160505.14060698.davem@davemloft.net>
	<1221088512.13621.58.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 10 Sep 2008 16:15:11 -0700

> It's definitely not something we should be doing upstream though.

So you think it's ok that every Debian user has to learn this
magic incantation just to use current kernels?

I don't think it's nice to break things like this on people,
especially such a large group.  Getting this stuff to work is hard
enough, and we're just putting yet another barrier into the situation
and that can only mean less testers and contributors.

I do know several people who aren't testing and contributing because
the whole firmware shakeup is so bolixed and they really are exasperated
after spending hours trying to get it to work.

This costs people's time, which is valuable.

I hate to say it, but this kind of attitude seems to be pervasive
every time some negative ramification of the firmware changes shows
up.
