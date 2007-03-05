Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbXCEISy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbXCEISy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXCEISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:18:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXCEISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:18:53 -0500
Date: Mon, 5 Mar 2007 00:13:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-Id: <20070305001358.2eebbfae.akpm@linux-foundation.org>
In-Reply-To: <20070305075747.GA19838@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015040.GJ3441@stusta.de>
	<20070305075747.GA19838@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 08:57:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
> > References : http://lkml.org/lkml/2007/2/21/208
> > Submitter  : Daniel Walker <dwalker@mvista.com>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Status     : problem is being debugged
> 
> FYI, this is not a "wont boot" problem, this should be a "NMI watchdog 
> does not work" problem - which has far lower severity. Also, Thomas did 
> a fix for this which is now in -mm.
>

yup, you should be able to cross this one off, Adrian.  The fix worked for me,
at least.
