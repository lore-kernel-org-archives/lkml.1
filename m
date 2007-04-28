Return-Path: <linux-kernel-owner+w=401wt.eu-S1163413AbXD1SJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163413AbXD1SJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163409AbXD1SJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:09:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53036 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163377AbXD1SJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:09:10 -0400
Message-ID: <46338DBA.2050404@garzik.org>
Date: Sat, 28 Apr 2007 14:08:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Simon Arlott <simon@arlott.org>, Dave Jones <davej@codemonkey.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] [16/35] i386: Add an option for the VIA C7 which sets
 appropriate L1 cache
References: <20070428752.712152000@suse.de> <20070428175240.E6704151CA@wotan.suse.de>
In-Reply-To: <20070428175240.E6704151CA@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Simon Arlott <simon@arlott.org>
> 
> The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also has
> a cache line length of 64 according to
> http://www.digit-life.com/articles2/cpu/rmma-via-c7.html.  This patch sets
> gcc to -march=686 and select s the correct cache shift.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Has it been verified in the field that this CPU supports CMOV?

	Jeff



