Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZCYQer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZCYQer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZCYQeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:34:36 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48948 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940AbZCYQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:34:35 -0400
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh65h)
X-Spam-TCS-SCL: 4:0
Message-ID: <49CA5CFF.8090908@am.sony.com>
Date: Wed, 25 Mar 2009 09:34:07 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk>
In-Reply-To: <20090325084248.GF4697@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 16:34:09.0450 (UTC) FILETIME=[85C840A0:01C9AD67]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> As pointed out in my previous mail, identifying where on the stack the
> return address is stored is only possible for OABI with frame pointers.
> 
> EABI will probably be possible with the stack unwinding code, but it
> probably won't be cheap.  The EABI unwinder is scheduled for merging
> during the present now-open merge window.
> 

-finstrument-functions is looking better and better.  I know it
adds more overhead than the mcount call, and may wreak havoc with
the dynamic ftrace mechanisms, but at least the callouts are
simple, clear, and you get both entry and exit, at fixed
costs.  I'll take a look at the EABI unwinder to see
what kind of variability it introduces (e.g. if it does a stack
scan or something).

Thanks very much for the information!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

