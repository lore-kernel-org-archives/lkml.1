Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYDTWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYDTWS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYDTWRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:17:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50781 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbYDTWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:17:49 -0400
Message-ID: <480BC0FC.8020908@garzik.org>
Date: Sun, 20 Apr 2008 18:17:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>	<20080418164411.b1e1628d.akpm@linux-foundation.org>	<48093AF3.2080807@garzik.org> <20080418181741.d6f365c5.akpm@linux-foundation.org>
In-Reply-To: <20080418181741.d6f365c5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I didn't realise you'd changed all the interrupt handlers too.  Good luck
> with that :)

Hey, I did, and last time I checked (months ago, to be honest) it boots 
on x86 :)


> Is it a flag day or do we have a migration plan?  I'd have thought that we
> could do a request_irq_new(irqreturn_t (*)(void *d)) and keep things
> compatible?
> 
> 
> 
> <checks>
> 
> Actually, that tree applies reasonably sanely to the full -mm lineup. 
> There are rejects of course, but they're easily fixed and a lot are due to
> file motion which git will handle anyway,
> 
> The bigger problem is newly-added irq handlers which your patch doesn't
> know about:
> 
> y:/usr/src/25> grep '^+.*request_irq[(]' patches/*.patch | wc -l
> 74
> 
> If we had a migration plan (ie: request_irq_new(), above) then this of
> course wouldn't be a problem.

A fair comment...

My goal has been to get the tree to the point where a flag-day patch 
"make the obvious change to each irq handler" /could/ be applied -- 
following the lead of the huge 'pt_regs arg removal' that went in in Oct 
2006.

Since I knew reaching that point would take time -- I started this 
project in Aug/Sep 2006 -- I simply didn't bother with a migration plan 
at the time.  I figured once the tree was prepped, which has taken over 
a year, _then_ I would waste maintainers' time discussing migration.

	Jeff


