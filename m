Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbXBWWcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbXBWWcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXBWWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:32:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50600
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933247AbXBWWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:32:51 -0500
Date: Fri, 23 Feb 2007 14:32:24 -0800 (PST)
Message-Id: <20070223.143224.74748313.davem@davemloft.net>
To: johnstul.lkml@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: radeon breaks with clocksource_jiffies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1f1b08da0702231410x24728480n463d08540c1c665f@mail.gmail.com>
References: <20070223.134505.74749340.davem@davemloft.net>
	<20070223.140328.74752162.davem@davemloft.net>
	<1f1b08da0702231410x24728480n463d08540c1c665f@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "john stultz-lkml" <johnstul.lkml@gmail.com>
Date: Fri, 23 Feb 2007 14:10:07 -0800

> Check out the patch I sent out yesterday. It should resolve this problem.

Yep, changing that finished_booting setting into an fs_initcall()
fixes this issue.
