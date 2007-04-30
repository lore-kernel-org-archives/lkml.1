Return-Path: <linux-kernel-owner+w=401wt.eu-S1946088AbXD3QV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946088AbXD3QV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946307AbXD3QV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:21:28 -0400
Received: from www.osadl.org ([213.239.205.134]:54067 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946306AbXD3QVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:21:23 -0400
Subject: Re: Linux 2.6.21: pmtmr losing time
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Joerg Sommrey <jo@sommrey.de>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070430125200.GA5379@sommrey.de>
References: <20070430125200.GA5379@sommrey.de>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 18:23:36 +0200
Message-Id: <1177950216.5791.241.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 14:52 +0200, Joerg Sommrey wrote:
> Hi all,
> 
> after switching to 2.6.21 the system clock sporadically loses time on my
> box (i386, Athlon MP).
> It's always around 4.68 seconds and happened 7 times in the last 12
> hours.  A simple calculation (2 ^ ACPI_PM_MASK / PMTMR_TICKS_PER_SEC =
> 2 ^ 24 / 3579545 = 4.686968875) shows: There is almost exactly one
> pmtmr-cycle missing.  Could this be caused by a pmtmr-wrap when the
> system is in a sleep state? 

Hmm, looks like. That's strange we don't sleep 4.68 seconds. Can you
provide me the output of /proc/timer_list please ?

	tglx


