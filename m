Return-Path: <linux-kernel-owner+w=401wt.eu-S966102AbXDBX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966102AbXDBX0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966103AbXDBX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:26:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966102AbXDBX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:26:45 -0400
Message-ID: <461190F6.3060108@zytor.com>
Date: Mon, 02 Apr 2007 16:25:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       cpufreq@lists.linux.org.uk, ak@suse.de, davej@codemonkey.org.uk
Subject: Re: [PATCH 3/3] cpuid: switch to cpuid_on_cpu()
References: <20070402113947.GC6785@localhost.sw.ru>
In-Reply-To: <20070402113947.GC6785@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Now that cpuid_on_cpu() is in core, cpuid driver can be shrinked.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Hi Alexey,

This, and your other changes in this area does conflict with the work 
that I've been doing on extending the usability of the CPUID and MSR 
drivers (which is part of why this work has dragged out seemingly forever.)

I would really appreciate it if we could work together on this; there 
needs to be new paravirtualization entry points for this.  Consequently, 
I just updated and uploaded a git tree with the current status.  It 
still needs porting to x86-64, however.

The current cpuid/msr work is at:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-cpuidmsr.git;a=summary

	-hpa
