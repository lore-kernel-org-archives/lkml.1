Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbXGEUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbXGEUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXGEUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:10:21 -0400
Received: from www.osadl.org ([213.239.205.134]:46981 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758255AbXGEUKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:10:19 -0400
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468D2EF1.7050908@nortel.com>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com>
	 <200707041056.53992.u.luckas@road.de>
	 <20070704165313.GC4306@sequoia.sous-sol.org> <468CFCA1.3080104@anagramm.de>
	 <468D2EF1.7050908@nortel.com>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 22:10:16 +0200
Message-Id: <1183666216.3289.41.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 11:48 -0600, Chris Friesen wrote:
> Clemens Koller wrote:
> 
> > Okay, we all survived Y2K and this little glitch. Puh! ;-)
> > Can you please explain in which configuration this problem got triggered.
> 
> As far as I can tell many kernel versions contained the source code bug. 
>   (I'd like some more information on exactly what the problem was if 
> anyone cares to share..the proposed patch didn't give much in the way of 
> specifics.)

It only happens with CONFIG_HIGHRES_TIMERS=y otherwise clock_was_set()
is a NOP. So only the 2.6.21 kernel and i386 and ARM are affected.

	tglx


