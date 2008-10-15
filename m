Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYJOQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYJOQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYJOQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:20:33 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10256 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYJOQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:20:32 -0400
X-BigFish: VPS-37(z21eWz1432R98dR936eQ1805M179dR6633jzzzz2ba5M867bjz32i6bh87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K8SG1S-01-0WU-01
Date: Wed, 15 Oct 2008 10:21:43 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Antipov Dmitry <dmantipov@yandex.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Message-ID: <20081015162143.GA19397@cosmic.amd.com>
References: <414861224052797@webmail58.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <414861224052797@webmail58.yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 Oct 2008 16:20:24.0158 (UTC) FILETIME=[ED5CEFE0:01C92EE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/08 10:39 +0400, Antipov Dmitry wrote:
> After updating the kernel to 2.6.27 from 2.6.25.4, my system time goes wrong and
> CPU becomes 0 MHz (as shown by /proc/cpuinfo), probably due to these issues:
> 
> TSC: Unable to calibrate against PIT
> TSC: No reference (HPET/PMTIMER) available
> Marking TSC unstable due to could not calculate TSC khz
> 
> The hardware is http://www.fit-pc.com/new/fit-pc-1-0-specifications.html,
> and the base system is Fedora 9.
> 
> More details: 2.6.25.4 .config: http://78.153.153.8/tmp/config-2.6.25.4.txt
>               2.6.25.4 boot messages: http://78.153.153.8/tmp/boot-2.6.25.4.txt
>               2.6.27 .config: http://78.153.153.8/tmp/config-2.6.27.txt
>               2.6.27 boot messages: http://78.153.153.8/tmp/boot-2.6.27.txt

Hmmm - this is an interesting regression.  Please remove
CONFIG_GEODE_MFGPT_TIMER=y from your 2.6.27 kernel and see if the
problem goes away.  I have been running 2.6.26.5 on my system with no
problems, but I'm embarrassed to admit that I haven't run anything
newer in a while.  

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

