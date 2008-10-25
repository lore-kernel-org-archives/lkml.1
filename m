Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYJYHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYJYHUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 03:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJYHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 03:20:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54499
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYJYHUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 03:20:02 -0400
Date: Sat, 25 Oct 2008 00:19:40 -0700 (PDT)
Message-Id: <20081025.001940.251852864.davem@davemloft.net>
To: efault@gmx.de
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224914333.3822.18.camel@marge.simson.net>
References: <1224905848.5161.27.camel@marge.simson.net>
	<20081024.221653.23695396.davem@davemloft.net>
	<1224914333.3822.18.camel@marge.simson.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>
Date: Sat, 25 Oct 2008 07:58:53 +0200

> I spent long day manweeks trying to bisect and whatnot.  It's immune to
> my feeble efforts, and my git-foo.

I understand, this is what happened to me when I tried to look into
the gradual tbench regressions since 2.6.22

I guess the only way to attack these things is to analyze the code and
make some debugging hacks to get some measurements and numbers.
