Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYKTRkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYKTRkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYKTRkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:40:04 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17127 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYKTRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:40:03 -0500
X-BigFish: VPS-10(zz98dRzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4925A0BC.7050207@am.sony.com>
Date: Thu, 20 Nov 2008 09:39:08 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init/main.c: Use ktime accessor function in initcall_debug
 code.
References: <87a5b0800811200647t4de76a2ah683ac6083014d061@mail.gmail.com>
In-Reply-To: <87a5b0800811200647t4de76a2ah683ac6083014d061@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 17:39:09.0393 (UTC) FILETIME=[E4B19410:01C94B36]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:
> The initcall_debug code access the tv64 member of ktime. This won't work
> correctly for large deltas on platforms that don't use the scalar ktime
> implementation.

In principle I see no problem with this.  But as a matter of
practice it may be overkill.

How big does the delta have to be for this to be a problem?
And how much overhead does ktime_to_ns() add?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

