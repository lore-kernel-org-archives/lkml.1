Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYIJVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYIJVkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYIJVkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:40:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39276
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbYIJVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:40:06 -0400
Date: Wed, 10 Sep 2008 14:40:00 -0700 (PDT)
Message-Id: <20080910.144000.111159506.davem@davemloft.net>
To: david-b@pacbell.net
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       alessandro.zummo@towertech.it, tglx@linutronix.de
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809101436.26162.david-b@pacbell.net>
References: <200809101419.05499.david-b@pacbell.net>
	<20080910.142047.265458325.davem@davemloft.net>
	<200809101436.26162.david-b@pacbell.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Wed, 10 Sep 2008 14:36:25 -0700

> Of course, you're very unlikely to sleep while waiting for that
> mutex; or even while holding it, if you stick to Sun hardware.
> Someone running Linux on one of the FPGA-based SPARCs might well
> use an I2C based RTC though.

There are at least one or two sparc workstations and/or servers that
use an I2C based RTC, I just haven't written the driver yet :)
