Return-Path: <linux-kernel-owner+w=401wt.eu-S1161520AbXEDSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161520AbXEDSlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161607AbXEDSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:41:08 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:6880 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161520AbXEDSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:41:06 -0400
Message-ID: <463B7E20.7070206@interia.pl>
Date: Fri, 04 May 2007 20:40:32 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> <463B687D.1020600@interia.pl> <463B7097.7070300@redhat.com>
In-Reply-To: <463B7097.7070300@redhat.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-EMID: 7a4e0acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> 
> The below is in the cpufreq git tree.
> 
> (Maybe also ondemand needs to be disabled for Longhaul?)
Would be great. Is this possible? Just kidding. I don't like 
ondemand. It isn't doing anything good for C3. There is no 
significant difference between halt/ACPI C2/ACPI C3 on 533Mhz 
and 999MHz. Difference is when processor is *running*. With 
ondemand it is running very short on 533MHz. When I was 
testing ondemand my CPU was running max f most the time. With 
conservative it is running min f most the time. CPU is much 
cooler and it is running fanless for most the time. Best part 
is that conservative is doing more transitions when system is 
busy because it needs to do all the steps (66MHz step for me) 
from min (533) to max (999). Ondemand is doing only one 
transition - from min to max.
> From: Rafal Bilski <rafalbilski@interia.pl>
> Date: Sun, 22 Apr 2007 10:26:04 +0000 (+0200)
> Subject: [CPUFREQ] Longhaul - Revert Longhaul ver. 2
> X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fdavej%2Fcpufreq.git;a=commitdiff_plain;h=07844252ffd81ec192a62014bada1016c9703765
> 
> [CPUFREQ] Longhaul - Revert Longhaul ver. 2
> 
No. It is new thing in 2.6.21 which will stop Longhaul 
from changing frequencies. As usual tested by email. Works 
for one, not works for others. Without this patch older 
C3 will not change frequency. Longhaul will be disabled for 
good. But both processors which we are talking about are 
"Powersaver". New.



----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

