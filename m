Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbXAWUDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbXAWUDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXAWUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:03:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139AbXAWUDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:03:13 -0500
Date: Tue, 23 Jan 2007 12:02:45 -0800
From: Andrew Morton <akpm@osdl.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/3] Scheduled removal of SA_xxx interrupt flags
Message-Id: <20070123120245.ec3b0772.akpm@osdl.org>
In-Reply-To: <20070114081926.912658228@inhelltoy.tec.linutronix.de>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	<20070114081926.912658228@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jan 2007 08:33:45 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The name space cleanup of the interrupt request flags (SA_xxx -> IRQF_xxx)
> left a 6 month grace period for the old deprecated flags. Remove them.

fwiw, I'll make this [patch 3/3], so the kernel compiles OK at each step.

This is going to break a lot of external stuff.  We should have found a way
to make usage of SA_* emit deprecated warnings (or _some_ warning) to warn
people of impending doom.  But I can't immediately find a way of doing
that.

If we _can_ find a way of doing this, I suspect we'll need to do it, and
give people another six months.  It's going to get ugly out there.  We
shall see...


