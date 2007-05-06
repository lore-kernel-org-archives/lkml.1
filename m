Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXEFXJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXEFXJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXEFXJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:09:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:34387 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXEFXJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:09:46 -0400
Message-ID: <463E603D.3090000@tmr.com>
Date: Sun, 06 May 2007 19:09:49 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: =?ISO-8859-1?Q?Markus_Ko=DFmann?= <mkossmann_ml1@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: parallel port problems with 2.6.21_rc5 and   2.6.21_rc6_git3-20070410174235
References: <200704112040.23505.mkossmann_ml1@gmx.de> <20070503132513.e3db44e9.randy.dunlap@oracle.com>
In-Reply-To: <20070503132513.e3db44e9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 11 Apr 2007 20:40:23 +0200 Markus Koßmann wrote:
> 
>> When using either the unpatched  2.6.21_rc5   or SUSEs patched 
>> 2.6.21_rc6_git3-20070410174235 on a SUSE-10.2 x86_64 system the parallel port 
>> doesn't work right. If I "cat some_asciifile >/dev/lp0"  the output on my 
>> Epson Stylus Color 880 is unreadable.  "cat /dev/zero >/dev/lp0"  creates 
>> random characters on the paper. Printing using cups also doesn't work any 
>> more. 
>> Switching back to SUSEs  2.6.18.8-0.1 kernel fixes the problem.
>> Any Ideas, what might be broken here ? 
> 
> Nope, but I have the same problem.
> I'll dig into it some day, but it's not very high priority for me.
> 
At some point that could be a problem, I have a shared printer on 
parallel (and replacing a printer for 11x17 work isn't cheap), as well 
as one PL/IP requirement, which is embedded in industrial machinery not 
likely to be upgraded.

Non-critical in the sense that I'm sure I can run old kernels for a 
decade if needed, but hopefully something to be fixed. Since there's no 
regressions list any more, I guess we will all have to complain about 
problems individually. :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

