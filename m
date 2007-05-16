Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbXEPEXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbXEPEXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXEPEXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:23:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47285 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbXEPEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:23:07 -0400
Date: Tue, 15 May 2007 21:27:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Message-Id: <20070515212700.b400e8db.randy.dunlap@oracle.com>
In-Reply-To: <20070516031315.132DFDBA1@gherkin.frus.com>
References: <20070516031315.132DFDBA1@gherkin.frus.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:

> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
> It panics early enough that some of what I'm sure would be useful has
> already scrolled off the screen, and there's no scrollback buffer at
> that point.  If more detail is needed, I'll have to transcribe what I
> *can* see by hand.

or use digital camera photo of screen if you have such a camera.

It's a good idea to increase the screen virtual size by decreasing
the font size if your video driver supports that.

> Here's /proc/cpuinfo on the chance it will help someone track this down:
> 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 5
> model		: 9
> model name	: AMD-K6(tm) 3D+ Processor
> stepping	: 1
> cpu MHz		: 451.032
> cache size	: 256 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr mce cx8 pge mmx syscall 3dnow k6_mtrr
> bogomips	: 902.76
> clflush size	: 32


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
