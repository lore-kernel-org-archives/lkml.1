Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXGEVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXGEVSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762870AbXGEVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:17:59 -0400
Received: from www.osadl.org ([213.239.205.134]:37711 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762991AbXGEVR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:17:58 -0400
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468D5C72.4030200@nortel.com>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com>
	 <200707041056.53992.u.luckas@road.de>
	 <20070704165313.GC4306@sequoia.sous-sol.org> <468CFCA1.3080104@anagramm.de>
	 <468D2EF1.7050908@nortel.com> <1183666216.3289.41.camel@chaos>
	 <468D5C72.4030200@nortel.com>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 23:17:54 +0200
Message-Id: <1183670274.3289.44.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 15:02 -0600, Chris Friesen wrote:
> Thomas Gleixner wrote:
> 
> > It only happens with CONFIG_HIGHRES_TIMERS=y otherwise clock_was_set()
> > is a NOP. So only the 2.6.21 kernel and i386 and ARM are affected.
> 
> Are you certain?

At least for anything >= 2.6.16

> Vanilla 2.6.10 shows a clock_was_set() function.  Does it just not call 
> the dangerous code or something?

Ouch, the old posix timer code might be affected as well, but I did not
look.

> Also, our modified 2.6.10 has the high res timers patch applied, but the 
> config option is turned off and we were still affected.

You mean Anzingers high res patches. No idea about those.

	tglx


