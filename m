Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXDUAKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXDUAKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXDUAKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:10:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbXDUAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:10:15 -0400
Date: Fri, 20 Apr 2007 17:09:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled -EINVAL for invalid timevals in
 setitimer
Message-Id: <20070420170958.b388d949.akpm@linux-foundation.org>
In-Reply-To: <1176607762.3387.81.camel@localhost.localdomain>
References: <20070406102036.GF29169@stusta.de>
	<1175855360.28263.439.camel@localhost.localdomain>
	<20070414150302.GF3691@stusta.de>
	<1176607762.3387.81.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007 05:29:22 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 2007-04-14 at 17:03 +0200, Adrian Bunk wrote:
> > As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Worried-about-by: me

I guess if it starts biting people we can revert it from 2.6.22.x.
