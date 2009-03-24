Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZCXVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZCXVDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCXVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:03:37 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36870 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706AbZCXVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:03:36 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 17:03:36 EDT
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
Message-ID: <49C9470F.8090202@am.sony.com>
Date: Tue, 24 Mar 2009 13:48:15 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324202539.GA11672@elte.hu>
In-Reply-To: <20090324202539.GA11672@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2009 20:48:18.0957 (UTC) FILETIME=[DCC89BD0:01C9ACC1]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tim Bird <tim.bird@am.sony.com> wrote:
> 
>> My ultimate goal is to add function duration filtering, which is 
>> one of the nicer features of KFT (an older tracer I used to 
>> maintain out-of-mainline).  With all the ftrace and ringbuffer 
>> support already in mainline, this shouldn't be too hard, but I 
>> need to start with basic graph support on ARM first.
> 
> ah, function duration filtering - is that to only show functions 
> which have a duration beyond a certain (runtime configurable) value?

Exactly.  With KFT, you set a "mintime filter", and it removed from
the trace buffer any functions which were less than the threshhold.
This was not high cost, because you usually only removed the most
recently added function in the trace buffer.

This lets you focus on routines that last a long time.  I used
it mainly to find long-duration routines in early boot.
The initcall tracer serves a similar purpose, but not at the
same granularity.

It greatly extends the length of time you can trace, before the
buffer fills up.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

