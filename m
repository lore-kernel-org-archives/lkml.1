Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbXGCVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbXGCVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbXGCVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:02:42 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41292 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbXGCVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:02:41 -0400
Message-ID: <468AB95B.4050209@nortel.com>
Date: Tue, 03 Jul 2007 17:02:19 -0400
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060130 Red Hat/1.7.12-1.4.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arne Georg Gleditsch <argggh@dolphinics.no>
CC: Florian Attenberger <valdyn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <20070703135949.GB19565@master.home> <87hcol7en2.fsf@pelargir.dolphinics.no> <20070703150210.GA31495@master.home> <87d4z97bks.fsf@pelargir.dolphinics.no> <468AA364.2010000@nortel.com>
In-Reply-To: <468AA364.2010000@nortel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 21:02:21.0729 (UTC) FILETIME=[72DEE910:01C7BDB5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> Setting the date to just before midnight June 30 UTC and then running 
> the following as root triggered the crash on a modified 2.6.10.  Anyone 
> see anything wrong with the code below, or is this a valid indication of 
> a bug in the leap second code?


As a further data point, the test app triggers problems on x86 uniprocessor and 
SMP as well as arm uniprocessor.  On ppc64 we see the leap second being added, 
but it doesn't hang, while on ppc we don't even see the leap second being 
added--leading me to wonder if the leap second code even works for ppc32.

The above is all for modified 2.6.10.

Chris
