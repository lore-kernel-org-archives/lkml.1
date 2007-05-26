Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXEZWms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXEZWms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbXEZWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:42:40 -0400
Received: from pool-72-92-171-78.albyny.east.verizon.net ([72.92.171.78]:50951
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbXEZWmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:42:39 -0400
Message-ID: <4658B7DD.3060309@tmr.com>
Date: Sat, 26 May 2007 18:42:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: [2.6.21.1] resume doesn't run suspended kernel?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing susp2disk in 2.6.21.1 under FC6, to support reliable 
computing environment (RCE) needs. The idea is that if power fails, 
after some short time on UPS the system does susp2disk with a time set, 
and boots back every so often to see if power is stable.

No, I don't want susp2mem until I debug it, console come up in useless 
mode, console as kalidescope is not what I need.

Anyway, I pulled the plug on the UPS, and the system shut down. But when 
it powered up, it booted the default kernel rather than the test kernel, 
decided that it couldn't resume, and then did a cold boot.

I can bypass this by making the debug kernel the default, but WHY? Is 
the kernel not saved such that any kernel can be rolled back into memory 
and run? Actually, the answer is HELL NO, so I really ask if this is the 
intended mode of operation, that only the default boot kernel will restore.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
