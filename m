Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbZFOAy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbZFOAy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 20:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZFOAyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 20:54:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZFOAys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 20:54:48 -0400
Subject: Re: [PATCH -rt] include linux/delay.h in hwlat_detector
From: Jon Masters <jcm@redhat.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1245015102-22057-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1245015102-22057-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Sun, 14 Jun 2009 20:54:19 -0400
Message-Id: <1245027259.31611.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 23:31 +0200, Uwe Kleine-König wrote:
> This broke when compiling on i386 without X86_LOCAL_APIC because then
> arch/x86/include/asm/smp.h doesn't include asm/apic.h which in turn includes
> linux/delay.h.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jon Masters <jcm@redhat.com>
> ---

Oh, thanks. I will also look at better handling hotplug CPU just to make
Paul happy (probably just disable on hotplug as you'll need to restart
any testing then), though as he said, it's obvious one shouldn't be
removing CPUs at the same time as benchmarking.

Jon.


