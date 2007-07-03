Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXGCVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXGCVDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbXGCVCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:02:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881AbXGCVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:02:54 -0400
Message-ID: <468AB976.2010806@redhat.com>
Date: Tue, 03 Jul 2007 17:02:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Florian Attenberger <valdyn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <20070703135949.GB19565@master.home> <87hcol7en2.fsf@pelargir.dolphinics.no> <20070703150210.GA31495@master.home> <87d4z97bks.fsf@pelargir.dolphinics.no> <468AA364.2010000@nortel.com>
In-Reply-To: <468AA364.2010000@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2007 03:28 PM, Chris Friesen wrote:
> Arne Georg Gleditsch wrote:
> 
>> An interesting exercise might be to
>> code up a small program to call adjtimex with timex.status |= STA_INS,
>> to see if this can trigger the problem.
> 
> Setting the date to just before midnight June 30 UTC and then running
> the following as root triggered the crash on a modified 2.6.10.  Anyone
> see anything wrong with the code below, or is this a valid indication of
> a bug in the leap second code?
> 

Fixed:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b

