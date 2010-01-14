Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058Ab0ANJxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0ANJxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672Ab0ANJxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:53:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:49951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0ANJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:53:30 -0500
Date: Thu, 14 Jan 2010 01:53:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timers: Introduce the concept of timer slack for legacy
 timers
Message-ID: <20100114015329.402f7b01@infradead.org>
In-Reply-To: <20100113220755.7ad6286f.akpm@linux-foundation.org>
References: <20100109133744.29829988@infradead.org>
	<20100113135219.f7e8a2f9.akpm@linux-foundation.org>
	<20100113214528.41e2de4a@infradead.org>
	<20100113220755.7ad6286f.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 22:07:55 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> hm.
> 
> Have you any feeling for how much power this sort of thing saves?  I
> guess "change in interrupts per minute" would be easy to measure.

depends on what kind of system obviously. For a laptop, it's not all
that much, but for a cellphone it can be easily 30% to 40% extra
standby power.... a few wakeups per second already is a huge power
delta for those.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
