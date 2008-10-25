Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYJYFP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYJYFP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 01:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYJYFPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 01:15:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56072
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbYJYFPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 01:15:48 -0400
Date: Fri, 24 Oct 2008 22:15:25 -0700 (PDT)
Message-Id: <20081024.221525.259940836.davem@davemloft.net>
To: efault@gmx.de
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224907501.5161.36.camel@marge.simson.net>
References: <200810250025.35734.rjw@sisk.pl>
	<20081024.163111.244324800.davem@davemloft.net>
	<1224907501.5161.36.camel@marge.simson.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>
Date: Sat, 25 Oct 2008 06:05:01 +0200

> My test data indicates (to me anyway) that there is another source of
> localhost throughput loss in .27.  In that data, there is no hrtick
> overhead since I didn't have highres timers enabled, and computational
> costs added in .27 were removed.  Dunno where it lives, but it does
> appear to exist.

Disabling TSO on loopback doesn't fix that bit for you?

