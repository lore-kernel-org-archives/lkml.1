Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXKTGR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXKTGR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXKTGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:17:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36190
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759110AbXKTGRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:17:11 -0500
Date: Mon, 19 Nov 2007 22:17:10 -0800 (PST)
Message-Id: <20071119.221710.241875586.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: hpa@zytor.com, goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120053904.GG2472@hacking>
References: <20071120041600.GC2472@hacking>
	<47426C54.9020009@zytor.com>
	<20071120053904.GG2472@hacking>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Tue, 20 Nov 2007 13:39:05 +0800

> And you mean abs() is not in glibc, then where is it? Built in gcc?
> And what's more, why not put it in glibc?

Because the compiler knows things about the inputs and can
thus apply optimizations that a static implementation in glibc
that has to handle all forms of inputs cannot.
