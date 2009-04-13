Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZDMUpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZDMUpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDMUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:44:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55965
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbZDMUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:44:51 -0400
Date: Mon, 13 Apr 2009 13:44:42 -0700 (PDT)
Message-Id: <20090413.134442.199436809.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: holt@sgi.com, mchan@broadcom.com, benli@broadcom.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on
 BCM5701. Bisected.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090413175724.GA11076@xw6200.broadcom.net>
References: <20090408062559.GF10768@sgi.com>
	<20090408071204.GG10768@sgi.com>
	<20090413175724.GA11076@xw6200.broadcom.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Mon, 13 Apr 2009 10:57:24 -0700

> Thank you for doing this bisection Robin.  This, and the data you
> provided in your previous email is really helpful.  Unfortunately, they
> raise more questions than answers.
> 
> I reviewed this patch again, and it still looks correct to me.  It
> should be one big behavioral no-op.  Obviously something is wrong, but
> I'm not seeing the root cause at the moment.  I need to think about this
> some more.

Matt, look at James Bottomly's patch posted earlier today, he
describes the problem perfectly.
