Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbXLKRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbXLKRBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXLKRBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:01:06 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17519 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXLKRBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:01:05 -0500
Date: Tue, 11 Dec 2007 08:59:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Martin Bligh <mbligh@mbligh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc4-mm1
Message-Id: <20071211085943.4e7c77aa.randy.dunlap@oracle.com>
In-Reply-To: <475EB8B5.2090104@mbligh.org>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<475EB8B5.2090104@mbligh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 08:20:05 -0800 Martin Bligh wrote:

>  >    - Lots of device IDs have been removed from the e1000 driver and
>  > moved over to e1000e.  So if your e1000 stops working, you forgot
>  > to set CONFIG_E1000E.
> 
> 
> Wouldn't it make sense to just default this to on if E1000 was on?
> As far as I can see that's not true, which will screwing everybody
> for no good reason (plus breaking all the automated testing, etc etc)?
> Much though I love random refactoring, it is fairly painful to just
> keep changing the names of things.
> 
> 
> I can't see this compile failure posted anywhere:
> http://test.kernel.org/results/IBM/126049/build/debug/stderr
> 
> arch/x86/vdso/vdso32/sigreturn.S: Assembler messages:
> arch/x86/vdso/vdso32/sigreturn.S:23: Error: suffix or operands invalid 
> for `pop'
> 
> arch/x86/vdso/vdso32/syscall.S:25: Error: suffix or operands invalid for 
> `pop'
> make[1]: *** [arch/x86/vdso/vdso32/syscall.o] Error 1
> make: *** [arch/x86/vdso] Error 2

I see those on one build machine but not on another, so I thought
that it was a tools issue...


> Nor this one:
> http://test.kernel.org/results/IBM/126096/build/debug/stderr
> 
> drivers/char/hvcs.c: In function â€˜hvcs_openâ€™:
> drivers/char/hvcs.c:1180: error: wrong type argument to unary 
> exclamation mark

See http://marc.info/?l=linux-kernel&m=119700448119646
for patches.


---
~Randy
Features and documentation: http://lwn.net/Articles/260136/
