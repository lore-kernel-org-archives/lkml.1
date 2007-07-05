Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXGEVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXGEVDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXGEVDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:03:08 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:52337 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbXGEVDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:03:07 -0400
Message-ID: <468D5C72.4030200@nortel.com>
Date: Thu, 05 Jul 2007 15:02:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com> <200707041056.53992.u.luckas@road.de> <20070704165313.GC4306@sequoia.sous-sol.org> <468CFCA1.3080104@anagramm.de>	 <468D2EF1.7050908@nortel.com> <1183666216.3289.41.camel@chaos>
In-Reply-To: <1183666216.3289.41.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2007 21:02:46.0578 (UTC) FILETIME=[D6821120:01C7BF47]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> It only happens with CONFIG_HIGHRES_TIMERS=y otherwise clock_was_set()
> is a NOP. So only the 2.6.21 kernel and i386 and ARM are affected.

Are you certain?

Vanilla 2.6.10 shows a clock_was_set() function.  Does it just not call 
the dangerous code or something?

Also, our modified 2.6.10 has the high res timers patch applied, but the 
config option is turned off and we were still affected.

Chris
