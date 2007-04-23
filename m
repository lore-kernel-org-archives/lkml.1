Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXDWQjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXDWQjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDWQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:39:49 -0400
Received: from [70.254.190.220] ([70.254.190.220]:49947 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbXDWQjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:39:48 -0400
Date: Mon, 23 Apr 2007 16:39:45 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: BUG: Null pointer dereference (2.6.21-rc7)
In-Reply-To: <Pine.LNX.4.64.0704231356480.25153@server.thyself>
Message-ID: <Pine.LNX.4.64.0704231633210.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231356480.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, William Heimbigner wrote:
> On Mon, 23 Apr 2007, Andrew Morton wrote:
>>  It certainly is.  Are you able to identify an earlier kernel in which this
>>  didn't happen?  2.6.20?  An earlier 2.6.21-rcX?
>
> I'll try .18 and .20 and see where that gets me - this is my first time 
> trying to set up packet writing.

Ok, on 2.6.18, I still get the warning about a recursive lock, but no dump 
regarding a null pointer dereference. The command still fails, however, 
with pkt_get_last_written_failed. On 2.6.20, I get an error similar to the
one I orignally posted (first the recursive lock warning, seconds later,
null pointer dereference).

Not sure about the recursive lock, but something between .18 and .20 
happened such that the packet writing driver didn't fail gracefully.

On a side (offtopic) note, I noticed that ACPI support changed for the 
better in very recent kernels - on both .18 and .20, there were severe 
and early errors unless I specified acpi=off

I'll see if I can figure out exactly where from 2.6.18 to .20 things went 
wrong,
William Heimbigner
icxcnika@mar.tar.cc
