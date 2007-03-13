Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXCMT7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXCMT7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXCMT7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:59:09 -0400
Received: from www.osadl.org ([213.239.205.134]:43794 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933068AbXCMT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:59:07 -0400
Subject: Re: [6/6] 2.6.21-rc3: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>, Jiri Slaby <jirislaby@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org
In-Reply-To: <20070313125025.GW18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <20070313125025.GW18731@stusta.de>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 21:05:28 +0100
Message-Id: <1173816328.13341.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 13:50 +0100, Adrian Bunk wrote:
> Subject    : hrtimer_switch_to_hres():
>              wrong tick_init_highres() return value handling
> References : http://lkml.org/lkml/2007/3/6/262
> Submitter  : Linus Torvalds <torvalds@linux-foundation.org>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit 54cdfdb47f73b5af3d1ebb0f1e383efbe70fde9e
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : unknown

Linus merged the original patch, which solved the real problem. 

He just gave me a lesson how to do it right next time.

	tglx


