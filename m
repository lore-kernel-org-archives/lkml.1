Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425Ab0A2Vsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0A2Vsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864Ab0A2Vsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:48:38 -0500
Received: from www.tglx.de ([62.245.132.106]:43135 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0A2Vsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:48:37 -0500
Date: Fri, 29 Jan 2010 22:48:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 08/10] drivers/base: Convert dev->sem to mutex
In-Reply-To: <20100129211358.GA7265@suse.de>
Message-ID: <alpine.LFD.2.00.1001292246580.5926@localhost.localdomain>
References: <20100129203549.526478432@linutronix.de> <20100129203613.665951035@linutronix.de> <20100129211358.GA7265@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Greg KH wrote:

> On Fri, Jan 29, 2010 at 08:39:02PM -0000, Thomas Gleixner wrote:
> > The semaphore is semantically a mutex. Convert it to a real mutex and
> > clean up all users outside of drivers/base as well.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Can you take that via your drivers tree or do you want me to push it
linuswards for .34 ?

Thanks,

	tglx

