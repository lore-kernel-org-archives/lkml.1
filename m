Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXLKQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXLKQoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXLKQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:44:28 -0500
Received: from dvhart.com ([64.146.134.43]:47732 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbXLKQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:44:27 -0500
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 11:44:27 EST
Message-ID: <475EB8B5.2090104@mbligh.org>
Date: Tue, 11 Dec 2007 08:20:05 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >    - Lots of device IDs have been removed from the e1000 driver and
 > moved over to e1000e.  So if your e1000 stops working, you forgot
 > to set CONFIG_E1000E.


Wouldn't it make sense to just default this to on if E1000 was on?
As far as I can see that's not true, which will screwing everybody
for no good reason (plus breaking all the automated testing, etc etc)?
Much though I love random refactoring, it is fairly painful to just
keep changing the names of things.


I can't see this compile failure posted anywhere:
http://test.kernel.org/results/IBM/126049/build/debug/stderr

arch/x86/vdso/vdso32/sigreturn.S: Assembler messages:
arch/x86/vdso/vdso32/sigreturn.S:23: Error: suffix or operands invalid 
for `pop'

arch/x86/vdso/vdso32/syscall.S:25: Error: suffix or operands invalid for 
`pop'
make[1]: *** [arch/x86/vdso/vdso32/syscall.o] Error 1
make: *** [arch/x86/vdso] Error 2


Nor this one:
http://test.kernel.org/results/IBM/126096/build/debug/stderr

drivers/char/hvcs.c: In function ‘hvcs_open’:
drivers/char/hvcs.c:1180: error: wrong type argument to unary 
exclamation mark
